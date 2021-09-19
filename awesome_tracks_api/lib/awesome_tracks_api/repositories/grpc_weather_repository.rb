# frozen_string_literal: true

this_dir = File.expand_path(__dir__)

$LOAD_PATH.unshift(this_dir) unless $LOAD_PATH.include?(this_dir)

require 'weather_service_pb'
require 'weather_service_services_pb'

module AwesomeTracksApi
  module Repositories
    class GRPCWeatherRepository
      include Result::Methods

      def temperature(request)
        stub = WeatherService::Service::Stub.new('weather_service:3000', :this_channel_is_insecure)

        result = stub.temperature(WeatherService::TemperatureRequest.new(city: request.fetch(:city)))

        return failure(result.error) unless result.success

        success(result.value)
      rescue StandardError => e
        failure(e.message)
      end
    end
  end
end
