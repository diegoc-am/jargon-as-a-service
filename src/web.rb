# frozen_string_literal: true

require 'sinatra/base'

module Jargon
  class Web < ::Sinatra::Base
    set :root, File.expand_path(__dir__)
    set :public_folder, File.join(root, 'public')
    set :views, File.join(root, 'views')

    get '/' do
      dataset = if params[:id]
                  Repository::Phrases.find(id: params[:id])&.to_hash
                else
                  Repository::Phrases.sample
                end

      @host = ENV['HOST']
      @meta_image = "/img/#{dataset[:category]}.png"
      @meta_title = dataset[:phrase]
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
