# frozen_string_literal: true

require 'json'

module WeatherService
  class OpenWeatherMapRepository
    def initialize(client:, logger:)
      @client = client
      @logger = logger
    end

    def temperature_by_city(city)
      response = @client.get("http://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=b77e07f479efe92156376a8b07640ced")
      body = JSON.parse(response.body)
      Float(body.dig('main', 'temp'))
    rescue StandardError => e
      @logger.error(e)
    end
  end
end
