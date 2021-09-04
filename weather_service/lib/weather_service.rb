# frozen_string_literal: true

require 'faraday'
require 'redis'
require 'weather_service/open_weather_map_cached_repository'
require 'weather_service/open_weather_map_repository'
require 'weather_service/logger'

module WeatherService
  module_function

  def temperature(request)
    $stdout.sync = true

    client = Faraday.new(request: { timeout: 5 }) { |f| f.use Faraday::Response::RaiseError }

    logger = Logger.new

    cache = Redis.new(host: 'cache')

    repository = OpenWeatherMapRepository.new(client: client, logger: logger)

    cached_repository = OpenWeatherMapCachedRepository.new(repository: repository, cache: cache, logger: logger)

    cached_repository.temperature_by_city(request.city)
  end
end
