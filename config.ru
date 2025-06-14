# frozen_string_literal: true

require 'logger'
require 'active_support'
require 'rack'
require 'rack/attack'
require 'rack/contrib'

require_relative 'src/api'

use Rack::Attack
use Rack::CommonLogger, Logger.new($stdout)
use Rack::ShowExceptions
use Rack::Lint
use Rack::ContentLength

Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
Rack::Attack.throttled_response_retry_after_header = true
Rack::Attack.throttle('req/ip', limit: 60, period: 60, &:ip)

map '/' do
    use Rack::Static,
    :urls => ["/images", "/js", "/css"],
    :root => "public"

    run lambda { |env|
    [
        200,
        {
        'content-type'  => 'text/html',
        'cache-control' => 'public, max-age=86400'
        },
        File.open('src/public/index.html', File::RDONLY)
    ]
    }
end

map '/api' do
    run Jargon::API
end
