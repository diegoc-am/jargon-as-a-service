require 'sinatra/base'

module Jargon
  class Web < ::Sinatra::Base
    set :root, File.expand_path(__dir__)
    set :public_folder, File.join(root, 'public')
    set :views, File.join(root, 'views')

    get '/' do
        category = params[:category] || Phrases.categories.keys.sample
        phrases = Phrases.categories[category]
        id = params[:id] ? params[:id].to_i : rand(1..phrases.size)

        @phrase = Phrases.categories[category][id - 1]
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
