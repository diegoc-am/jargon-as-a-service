# frozen_string_literal: true

require 'json'

module Jargon
  module Repository
    class Phrases
      class << self
        def categories
          return @categories if defined?(@categories)
  
          load_categories!
        end
  
        def load_categories!
          @categories = {}
          Dir.glob('src/assets/jargon/*.json').tap { |x| puts "Found #{x.join(',')}" }.each do |file_path|
            category_name = File.basename(file_path, '.json')
            puts "Loading phrases for category: #{category_name}"
            @categories[category_name] = load_phrases(file_path).each_with_index.map do |phrase, index|
                { id: index + 1, category: category_name, phrase: phrase }
            end
          end
          @categories
        end
  
        def load_phrases(file_path)
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
