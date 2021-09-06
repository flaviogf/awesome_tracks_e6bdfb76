# frozen_string_literal: true

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

      value = body.dig('main', 'temp').to_f

      success(value)
    rescue StandardError => e
      @logger.error(e)

      failure("could not get temperature for city: #{city}")
    end
  end
end
