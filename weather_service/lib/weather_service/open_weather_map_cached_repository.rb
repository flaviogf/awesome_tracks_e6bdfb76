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
      value = cache(city) { |key| @repository.temperature_by_city(key) }

      success(value)
    rescue StandardError => e
      @logger.error(e)

      failure("could not get temperature for city: #{city}")
    end

    private

    def cache(key)
      record = @cache.get(key)
      return Float(record) unless record.nil?

      record = yield(key)
      @cache.set(key, record, ex: 60 * 30)
      record
    end
  end
end
