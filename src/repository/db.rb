# frozen_string_literal: true

require 'sqlite3'
require 'sequel'

module Jargon
  module Repository
    class DB
      class << self
        def connection
          return @connection if defined?(@connection)

          @connection = Sequel.sqlite(loggers: [Logger.new($stdout)])
          Sequel.extension :migration
          Sequel::Migrator.run(@connection, 'src/db/migrations/', use_transactions: true)
          @connection
        end

        def load_phrases!
          Dir.glob('src/assets/jargon/*.json').tap { |x| puts "Found #{x.join(',')}" }.each do |file_path|
            category_name = File.basename(file_path, '.json')
            puts "Loading phrases for category: #{category_name}"
            read_phrases_file(file_path).each do |phrase|
              DB.connection[:phrases].insert(category: category_name, phrase: phrase)
            end
          end
        end

        def read_phrases_file(file_path)
          return [] unless File.exist?(file_path)

          begin
            file_content = File.read(file_path)
            JSON.parse(file_content, symbolize_names: true)
          rescue JSON::ParserError => e
            puts "Error parsing JSON from #{file_path}: #{e.message}"
            []
          end
        end
      end
    end
  end
end
