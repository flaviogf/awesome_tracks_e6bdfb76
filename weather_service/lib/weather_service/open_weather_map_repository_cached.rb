# frozen_string_literal: true

module WeatherService
  class OpenWeatherMapRepositoryCached
    def initialize(repository:, cache:, logger:)
      @repository = repository
      @cache = cache
      @logger = logger
    end

    def temperature_by_city(city)
      cache(city) { |key| @repository.temperature_by_city(key) }
    rescue StandardError => e
      @logger.error(e)
    end

    private

    def cache(key)
      record = @cache.get(key)
      return record unless record.nil?

      record = yield(key)
      @cache.set(key, record, ex: 60 * 30)
      record
    end
  end
end
