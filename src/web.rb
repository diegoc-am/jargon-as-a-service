require 'sinatra/base'

module Jargon
  class Web < ::Sinatra::Base
    set :root, File.expand_path(__dir__)
    set :public_folder, File.join(root, 'public')
    set :views, File.join(root, 'views')

    get '/' do
      category = if params[:category] && Repository::Phrases.categories.key?(params[:category])
        params[:category]
      else 
        Repository::Phrases.categories.keys.sample
      end

      phrases = Repository::Phrases.categories[category]
      
      id = if params[:id].to_i if params[:id].to_i > 0 && params[:id].to_i <= phrases.size
        params[:id].to_i
      else
        id = rand(1..phrases.size)
      end
        
      @host = ENV['HOST']
      @meta_image = "/img/#{category}.png"
      @meta_title = Repository::Phrases.categories[category][id - 1]
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
