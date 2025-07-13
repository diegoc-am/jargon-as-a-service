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
      return Repository::Phrases.where(category: params[:category]).select(:id, :phrase).map(&:to_hash)
    end

    get '/phrases/:category/sample' do
      category = params[:category]
      return Repository::Phrases.sample(category: category)

      error!({ error: 'Category not found' }, 404)
    end

    get '/phrases/:category/:id' do
      phrase = Repository::Phrases.find(category: params[:category], id: params[:id].to_i)&.to_hash
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
