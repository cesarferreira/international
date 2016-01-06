require 'erb'
require 'erubis'

class AndroidManager

  def initialize language, items
    @language = language
    @items = items
    @template = File.read('./templates/android.erb')
  end

  def create_file
    file_name = "values-#{@language}/strings.xml"
    puts "# #{file_name}"
    puts self.render
  end

  def render
    ERB.new(@template).result(binding)
  end
end
