# frozen_string_literal: true

require 'json'
require_relative 'db'

module Jargon
  module Repository
    
    class Phrases < Sequel::Model(DB.connection[:phrases])
        

        def self.categories
            self.distinct.select(:category).map(:category)
        end

        def self.sample(category: nil)
            dataset = self

            if category
                dataset = dataset.where(category: category)
            end

            dataset.order(Sequel.lit('RANDOM()')).limit(1).first&.to_hash
        end
    end
  end
end
