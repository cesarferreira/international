require 'colorize'
require 'international/version'
require 'csv'
require 'android_manager'

module International

  class MainApp

    def initialize(arguments)

      # defaults
      @path_to_output = 'output/'
      @path_to_csv = nil
      @dryrun = false

      # Parse Options
      arguments.push "-h" if arguments.length == 0
      create_options_parser(arguments)

      manage_opts

    end

    ### Options parser
    def create_options_parser(args)

      args.options do |opts|
        opts.banner = "Usage: international [OPTIONS]"
        opts.separator  ''
        opts.separator  "Options"

        opts.on('-c PATH_TO_CSV', '--csv PATH_TO_CSV', 'Path to the .csv file') do |csv_path|
          @path_to_csv = csv_path
        end

        opts.on('-o PATH_TO_OUTPUT', '--output PATH_TO_OUTPUT', 'Path to the desired output folder') do |path_to_output|
          unless path_to_output[0,1] == '/'
            path_to_output = "#{path_to_output}/"
          end

          @path_to_output = path_to_output
        end

        opts.on('-d', '--dryrun', 'Only simulates the output and don\'t write files') do |aa|
          @dryrun = true
        end

        opts.on('-h', '--help', 'Displays help') do
          @require_analyses = false
          puts opts.help
          exit
        end
        opts.on('-v', '--version', 'Displays version') do
          @require_analyses = false
          puts International::VERSION
          exit
        end
        opts.parse!

      end
    end

    ### Manage options
    def manage_opts

      unless @path_to_csv
        puts "Please give me a path to a CSV".yellow
        exit 1
      end

      hash = csv_to_hash(@path_to_csv)
      separate_languages hash
    end

    ### CSV TO HASH
    def csv_to_hash(path_to_csv)
      file = File.open(path_to_csv, "rb")
      body = file.read

      body = "key#{body}" if body[0,1] == ','

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
        all.each do |row|
          item = {
            :key => row.first.last, # dem hacks
            :translation => row[lang]
          }

          items.push item
        end

        manager = AndroidManager.new lang, items, @path_to_output, @dryrun
        manager.create_file
      end
    end

  end
end
