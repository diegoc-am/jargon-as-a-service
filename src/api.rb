# frozen_string_literal: true

require 'grape'
require_relative 'phrases'

module Jargon
  ##
  # Main API instatiation
  class API < Grape::API
    format :json
    prefix :api

    get '/status' do
      { status: :ok }
    end

    get '/phrases/:category' do
      category = params[:category]
      if Phrases.categories.key?(category)
        Phrases.categories[category].each_with_index.map do |phrase, index|
          { id: index + 1, phrase: phrase }
        end
      else
        error!({ error: 'Category not found' }, 404)
      end
    end

    get '/phrases/:category/sample' do
      category = params[:category]
      phrases = Phrases.categories[category]
      id = rand(1..phrases.size)
      if Phrases.categories.key?(category)
        {
          id: id,
          category: category,
          phrase: Phrases.categories[category][id - 1]
        }
      else
        error!({ error: 'Category not found' }, 404)
      end
    end

    get '/phrases/:category/:id' do
      category = params[:category]
      id = params[:id].to_i

      if Phrases.categories.key?(category)
        {
          id: id,
          category: category,
          phrase: Phrases.categories[category][id - 1]
        }
      else
        error!({ error: 'Category not found' }, 404)
      end
    end

    get '/categories' do
      {
        categories: Phrases.categories.keys
      }
    end

    get '/jargon' do
      category = Phrases.categories.keys.sample
      phrases = Phrases.categories[category]
      id = rand(1..phrases.size)
      {
        id: id,
        category: category,
        phrase: Phrases.categories[category][id - 1]
      }
    end
  end
end
