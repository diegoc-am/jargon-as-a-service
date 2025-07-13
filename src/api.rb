# frozen_string_literal: true

require 'grape'
require_relative 'repository/phrases'

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
      Repository::Phrases.categories[category] if Repository::Phrases.categories.key?(category)
      
      error!({ error: 'Category not found' }, 404)
    end

    get '/phrases/:category/sample' do
      category = params[:category]
      phrases = Repository::Phrases.categories[category]
      id = rand(1..phrases.size)
      
      return Repository::Phrases.categories[category][id - 1] if Repository::Phrases.categories.key?(category)
      
      error!({ error: 'Category not found' }, 404)
    end

    get '/phrases/:category/:id' do
      id = if params[:id].to_i if params[:id].to_i > 0 && params[:id].to_i <= phrases.size
        params[:id].to_i
      else
        id = rand(1..phrases.size)
      end

      category = params[:category]

      return Repository::Phrases.categories[category][id - 1] if Repository::Phrases.categories.key?(category)
          
      error!({ error: 'Category not found' }, 404)
    end

    get '/categories' do
      {
        categories: Repository::Phrases.categories.keys
      }
    end

    get '/jargon' do
      category = Repository::Phrases.categories.keys.sample
      phrases = Repository::Phrases.categories[category]
      id = rand(1..phrases.size)
      Repository::Phrases.categories[category][id - 1]
    end
  end
end
