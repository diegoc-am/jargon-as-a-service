# frozen_string_literal: true

require 'grape'
require_relative '../repository/phrases'

module Jargon
  module API
    class Phrases < Grape::API
      get '/phrases/:id_or_category' do
        phrase = Repository::Phrases.find(id: params[:id_or_category])&.to_hash
        return phrase if phrase

        category = Repository::Phrases.categories.include?(params[:id_or_category]) ? params[:id_or_category] : nil

        return Repository::Phrases.where(category: category).map(&:to_hash) if category

        error!({ error: 'Not found' }, 404)
      end

      get '/phrases/:category/sample' do
        category = params[:category]
        return Repository::Phrases.sample(category: category)

        error!({ error: 'Category not found' }, 404)
      end

      get '/phrases/:category/:id' do
        phrase = Repository::Phrases.find(category: params[:category], id: params[:id])&.to_hash
        return phrase if phrase

        error!({ error: 'Not found' }, 404)
      end

      get '/categories' do
        {
          categories: Repository::Phrases.categories
        }
      end

      get '/jargon' do
        Repository::Phrases.sample
      end
    end
  end
end
