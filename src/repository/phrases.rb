# frozen_string_literal: true

require 'json'
require_relative 'db'

module Jargon
  module Repository
    class Phrases < Sequel::Model(DB.connection[:phrases])
      def self.categories
        distinct.select(:category).map(:category)
      end

      def self.sample(category: nil)
        (category.nil? ? self : where(category: category)).order(Sequel.lit('RANDOM()')).limit(1).first&.to_hash
      end
    end
  end
end
