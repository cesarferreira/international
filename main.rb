require 'csv'
require 'pry'
require './android_manager'

class String
  def initial
    self[0,1]
  end
end

### CSV TO HASH
def csv_to_hash(path_to_csv)
  file = File.open(path_to_csv, "rb")
  body = file.read

  body = "key#{body}" if body.initial == ','

  CSV::Converters[:blank_to_nil] = lambda do |field|
    field && field.empty? ? nil : field
  end

  csv = CSV.new(body, :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil])

  csv.to_a.map {|row| row.to_hash }
end

def separate_languages(all)
  languages = all.first.keys.drop(1)
  separated = Hash.new

  languages.each do |lang|
    items = Array.new
    all.each do |value|
      obj = {
        :key => value[:key],
        :translation => value[lang]
      }
      items.push obj
    end

    manager = AndroidManager.new lang, items
    manager.create_file
  end
end

####################################################
####################################################

path_to_csv = "import.csv"

hash = csv_to_hash(path_to_csv)

languages = separate_languages hash

