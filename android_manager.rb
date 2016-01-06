require 'erb'
require 'erubis'
require 'fileutils'

class AndroidManager
  def initialize language, items
    @language = language
    @items = items
    @path = "#{Dir.pwd}/tmp/android/"
    @template = File.read('./templates/android.erb')
  end

  def create_file
    file_name = "values-#{@language}/strings.xml"
    destination_file_path =  "#{@path}#{file_name}"

    dirname = File.dirname(destination_file_path)
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end

    File.open(destination_file_path, 'a') { |f| f.write(self.render) }
  end

  def render
    ERB.new(@template).result(binding)
  end
end
