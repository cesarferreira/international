require 'erb'
require 'erubis'
require 'fileutils'
require 'colorize'

class AndroidManager
  def initialize language, items
    @language = language
    @items = items
    @path = "#{Dir.pwd}/tmp/android/"
    @template = File.read(get_template_path)
  end

  def get_template_path
    './templates/android.erb'
  end

  def get_file_name
    "values-#{@language}/translation.xml"
  end

  def create_file
    file_name = get_file_name
    destination_file_path =  "#{@path}#{file_name}"

    dirname = File.dirname(destination_file_path)
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end

    File.open(destination_file_path, 'w') { |f| f.write(self.render) }
    self.pretty_print destination_file_path
  end

  def pretty_print(path_to_file)
    subtracted = path_to_file.gsub("#{Dir.pwd}/",'')
    puts "created #{subtracted.green} successfully"
  end

  def render
    ERB.new(@template).result(binding)
  end
end
