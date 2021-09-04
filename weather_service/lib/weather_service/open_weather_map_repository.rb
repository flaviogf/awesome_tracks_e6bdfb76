# frozen_string_literal: true

require 'json'

module WeatherService
  class OpenWeatherMapRepository
    def initialize(client:)
      @client = client
    end

    def temperature_by_city(city)
      response = @client.get("http://api.openweathermap.org/data/2.5/weather?q=i#{city}&appid=b77e07f479efe92156376a8b07640ced")

      return if response.status != 200

      body = JSON.parse(response.body)

      Float(body.dig('main', 'temp'))
    end
  end
end
