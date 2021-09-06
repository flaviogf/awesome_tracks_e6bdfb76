# frozen_string_literal: true

require 'faraday'
require 'redis'

require 'weather_service/result'
require 'weather_service/logger'
require 'weather_service/open_weather_map_repository'
require 'weather_service/open_weather_map_cached_repository'

module WeatherService
  class << self
    include Result::Methods

    def temperature(request)
      cached_repository.temperature_by_city(request.city)
    rescue StandardError => e
      logger.error(e)

      failure(e.message)
    end

    private

    def cached_repository
      OpenWeatherMapCachedRepository.new(repository: repository, cache: cache, logger: logger)
    end

    def repository
      OpenWeatherMapRepository.new(client: client, logger: logger)
    end

    def client
      Faraday.new(request: { timeout: 5 }) { |f| f.use Faraday::Response::RaiseError }
    end

    def logger
      Logger.new
    end

    def cache
      Redis.new(host: 'cache', timeout: 5)
    end
  end
end
