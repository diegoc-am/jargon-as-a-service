# frozen_string_literal: true

require 'sinatra/base'

module Jargon
  class Web < ::Sinatra::Base
    set :root, File.expand_path(__dir__)
    set :public_folder, File.join(root, 'public')
    set :views, File.join(root, 'views')

    get '/' do
      category = if params[:category] && Repository::Phrases.categories.include?(params[:category])
                   params[:category]
                 else
                   Repository::Phrases.categories.sample
                 end

      dataset = if params[:id]&.to_i
                  Repository::Phrases.find(category: category, id: params[:id]&.to_i)&.to_hash
                else
                  Repository::Phrases.sample
                end

      @host = ENV['HOST']
      @meta_image = "/img/#{category}.png"
      @meta_title = dataset[:phrase] if dataset.key?(:phrase)
      erb :index
    end

    not_found do
      status 404
      'not found'
    end

    error do
      status 500
      'internal server error'
    end
  end
end
