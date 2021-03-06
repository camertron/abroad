# 4.6.0
* Bump json-write-stream to 2.0.0.
* Better support for dotted-key JSON.
* Serializer#open and Serializer#from_stream now accept an options hash that will be passed to the underlying stream object.

# 4.5.1
* Loosen nokogiri dependency.

# 4.5.0
* Add support for JSON dotted key format a la Rails YAML.

# 4.4.0
* Add spaces after colons in json key/value serialization.

# 4.3.0
* Nokogiri 1.8 seems to break htmlentities, so restrict the version in the gemspec.

# 4.2.1
* Fix handling of CDATA sections in Android XML.

# 4.2.0
* Add support for text files.

# 4.1.3
* Leave nils alone.

# 4.1.2
* Fix nested array YAML serialization.

# 4.1.1
* Array preservation should only affect string arrays (i.e. not nested objects).

# 4.1.0
* Provide option to preserve arrays when extracting and serializing YAML.

# 4.0.3
* Fix numeric coercion (fails for "." case).

# 4.0.2
* Coerce numeric values.

# 4.0.1
* Don't quote partially numeric keys.

# 4.0.0
* Don't treat numeric keys as array indices. Wrap them in quotes to disambiguate.

# 3.0.1
* Handle nil values in Rails YAML serializer (convert them to empty strings).

# 3.0.0
* Upgrade to yaml-write-stream v2, which dumps YAML scalars more consistently.

# 2.0.0
* Generate pretty JSON.
* Change serializer initialization method signature to accept hash of options.

# 1.0.0
* Birthday!
