# frozen_string_literal: true

require 'json'

module WeatherService
  class OpenWeatherMapRepository
    include Result::Methods

    API_KEY = ENV.fetch('OPEN_WEATHER_MAP_API_KEY', '').freeze

    def initialize(client:, logger:)
      @client = client
      @logger = logger
    end

    def temperature_by_city(city)
      response = @client.get("http://api.openweathermap.org/data/2.5/weather?q=#{city}&units=metric&appid=#{API_KEY}")

      body = JSON.parse(response.body)

      Success(Float(body.dig('main', 'temp')))
    rescue StandardError => e
      @logger.error(e)

      Failure("could not get temperature for city: #{city}")
    end
  end
end
