require 'csv'
require 'pry'
require './android_manager'


### CSV TO HASH
def csv_to_hash(path_to_csv)
  file = File.open(path_to_csv, "rb")
  body = file.read

  CSV::Converters[:blank_to_nil] = lambda do |field|
    field && field.empty? ? nil : field
  end
  csv = CSV.new(body, :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil])

  return csv.to_a.map {|row| row.to_hash }
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
    puts "-----------------------------------------"

  end
end

# def create_android_languages_from_template(language, translations)
#   template = File.read('templates/android.erb')
#   template = Erubis::Eruby.new(template)
# # TODO write to file
#   puts "#{language}_strings.xml"
#   puts template.result(@items)
# end

####################################################
####################################################

path_to_csv = "import.csv"

hash = csv_to_hash(path_to_csv)

languages = separate_languages hash

#a = create_android_languages_from_template nil

#a = Basicerb.new('cesar')
#puts a.render
