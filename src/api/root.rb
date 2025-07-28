# frozen_string_literal: true

require 'grape'
require 'grape-swagger'
require_relative 'jargon'

module Jargon
  module API
    ##
    # Root API instatiation
    class Root < Grape::API
      format :json
      prefix :api

      rescue_from :all do
        error!({ "error" => "Internal Server Error" }, 500)
      end

      get '/status' do
        { status: :ok }
      end

      mount API::Phrases
      add_swagger_documentation
    end
  end
end
