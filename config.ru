# frozen_string_literal: true

require 'logger'
require 'active_support'
require "rack/attack"

require_relative 'src/api'
use Rack::Attack
use Rack::CommonLogger, Logger.new(STDOUT)
use Rack::ShowExceptions
use Rack::Lint
use Rack::ContentLength

Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
Rack::Attack.throttled_response_retry_after_header = true
Rack::Attack.throttle('req/ip', limit: 60, period: 60) do |req|
    req.ip # unless req.path.start_with?('/assets')
end

run Jargon::API
