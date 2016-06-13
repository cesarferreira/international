require 'erb'
require 'erubis'
require 'fileutils'
require 'colorize'

class FileManager
  def initialize language, items, output_folder, platform, dryrun=false

    if language==nil
      puts "INTERRUPTION:\n"
      puts "Something is wrong with one of your language columns (maybe it's missing?)\n".red
      exit 1
    end

    @language = language.downcase
    @platform = platform
    @dryrun = dryrun
    @items = items
    @path = output_folder
    @template = File.read(get_template_path)
  end

  def get_template_path
    File.join(File.dirname(__FILE__), "templates/#{@platform}.erb")
  end

  def get_file_name
    if @platform.eql?'android'
      "values-#{@language}/translation.xml"
    else
      "#{@language}.lbproj/Localizable.strings"
    end
  end

  def create_file
    file_name = get_file_name
    destination_file_path = "#{@path}#{file_name}"

    pretty_print destination_file_path

    unless @dryrun

      dirname = File.dirname(destination_file_path)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end
      File.open(destination_file_path, 'w') { |f| f.write(render) }
    else
      puts render.yellow
    end
  end

  def pretty_print(path_to_file)
    subtracted = path_to_file.gsub("#{Dir.pwd}/",'')
    puts "created #{subtracted.green} successfully"
  end

  def render
    ERB.new(@template).result(binding)
  end
end
