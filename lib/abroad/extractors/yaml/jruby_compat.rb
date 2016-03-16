require 'yaml'

java_import 'java.lang.StringBuilder'

module Abroad
  module Extractors
    module Yaml
      # For some reason, Psych in MRI thinks it's valid yaml syntax to escape
      # single quotes (surprise, it's not). This class is a performant way to
      # identify and correct such invalid escaping. Be warned, it's a fairly
      # naïve implementation.
      #
      # NOTE: this technique will only work with YAML emitted in block mode,
      # i.e. yaml that uses indentation and newlines for each key/value pair
      # and array element
      class JRubyCompat

        UNKNOWN_ESCAPE_MSG = "found unknown escape character '(39)"
        UNEXPECTED_EOS_MSG = 'found unexpected end of stream while scanning a quoted scalar'

        class << self
          def clean(yaml_content)
            # convert to java string for performance reasons (don't have to
            # coerce/convert from java to ruby and back again)
            # https://github.com/jruby/jruby/wiki/ImprovingJavaIntegrationPerformance#pre-coerce-values-used-repeatedly
            yaml_content = yaml_content.to_java
            ranges = identify_ranges(yaml_content)
            reconstruct(yaml_content, ranges)
          end

          private

          # given a list of range/substitution pairs, reconstruct the yaml_content
          # string so it contains the substitutions
          def reconstruct(yaml_content, ranges)
            builder = StringBuilder.new
            index = 0

            ranges.each do |range|
              builder.append(yaml_content, index, range.first.first)
              builder.append(range.last)
              index = range.first.last
            end

            builder.append(yaml_content, index, yaml_content.length)
            builder.toString
          end

          # Find the problem areas in yaml_content. Returns a list of range/substitution
          # pairs of the form [[start, finish], substitution]
          def identify_ranges(yaml_content)
            each_line_indices(yaml_content).each_with_object([]) do |(start, finish), ranges|
              if range = clean_line(yaml_content, start, finish)
                ranges << range
              end
            end
          end

          def clean_line(yaml_content, start, finish)
            unless array_element?(yaml_content, start, finish)
              value_start, value_finish = find_value(yaml_content, start, finish)

              if value_start && double_quoted?(yaml_content, value_start, value_finish)
                clean_value(yaml_content, value_start, value_finish)
              end
            else
              clean_value(yaml_content, start, finish)
            end
          end

          # if the yaml parser (snakeyaml in jruby's case) can parse the value,
          # return nil. If not, attempt to fix the problem by returning
          # a range/substitution pair.
          def clean_value(yaml_content, start, finish)
            value = yaml_content.substring(start, finish)

            begin
              YAML.load(value)
              nil
            rescue Psych::SyntaxError => e
              if error_type = error_type_for(e)
                fix(error_type, yaml_content, start, finish, value)
              else
                raise e
              end
            end
          end

          # naïvely try to fix the problem by replacing escaped single quotes
          def clean_string(value)
            value.gsub("\\'", "'")
          end

          def fix(error_type, yaml_content, start, finish, value)
            # don't do anything with error type for now
            [[start, finish], clean_string(value)]
          end

          def error_type_for(e)
            if e.message.include?(UNKNOWN_ESCAPE_MSG)
              :unknown_escape_sequence
            elsif e.message.include?(UNEXPECTED_EOS_MSG)
              :unexpected_eos
            else
              :unknown
            end
          end

          # rather naïvely isolates the value in a yaml key/value pair by searching
          # for the first colon
          def find_value(yaml_content, start, finish)
            value_start = yaml_content.indexOf(':', start)

            if value_start <= finish
              [value_start + 1, finish]
            else
              [nil, nil]
            end
          end

          # is this chunk of text double-quoted?
          def double_quoted?(yaml_content, start, finish)
            starts_with?('"'.ord, yaml_content, start, finish)
          end

          # is this line of yaml an array element, i.e. does it begin with "-"?
          def array_element?(yaml_content, start, finish)
            starts_with?('-'.ord, yaml_content, start, finish)
          end

          def starts_with?(charcode, yaml_content, start, finish)
            (start..finish).each do |index|
              return false if index >= yaml_content.length
              unless yaml_content.charAt(index) == 32
                break yaml_content.charAt(index) == charcode
              end
            end
          end

          # Iterates over the yaml string and yields ranges that encapsulate
          # each "line". Expects lines to be delimited by newlines ("\n").
          def each_line_indices(yaml_content)
            if block_given?
              index = 0

              loop do
                next_index = yaml_content.indexOf("\n", index)

                if next_index == -1
                  if index < yaml_content.length
                    yield index + 1, yaml_content.length
                  end

                  break
                else
                  yield index, next_index + 1
                end

                index = next_index + 1
              end
            else
              to_enum(__method__, yaml_content)
            end
          end
        end

      end
    end
  end
end
