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
        { phrase: Phrases.categories[category].sample }
      else
        error!({ error: 'Category not found' }, 404)
      end
    end

    get '/categories' do
      {
        categories: Phrases.categories.keys
      }
    end
  end
end
