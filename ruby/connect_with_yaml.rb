require "bundler"
Bundler.require

require "yaml"

file_path = File.expand_path "../database.yaml", __FILE__
file = YAML.load_file file_path

db = Sequel.connect(file)

p db[:post]