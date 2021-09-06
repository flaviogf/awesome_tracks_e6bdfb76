# frozen_string_literal: true

module WeatherService
  class OpenWeatherMapCachedRepository
    include Result::Methods

    def initialize(repository:, cache:, logger:)
      @repository = repository
      @cache = cache
      @logger = logger
    end

    def temperature_by_city(city)
      value = @cache.get(city)

      return value.to_f unless value.nil?

      result = @repository.temperature_by_city(city)

      return result if result.failure?

      value = result.value

      @cache.set(city, value, ex: 60 * 30)

      success(value)
    rescue StandardError => e
      @logger.error(e)

      failure("could not get temperature for city: #{city}")
    end
  end
end
