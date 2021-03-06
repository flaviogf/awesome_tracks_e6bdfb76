# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: weather_service.proto for package 'weather_service'

require 'grpc'
require 'weather_service_pb'

module WeatherService
  module Service
    class Service

      include ::GRPC::GenericService

      self.marshal_class_method = :encode
      self.unmarshal_class_method = :decode
      self.service_name = 'weather_service.Service'

      rpc :Temperature, ::WeatherService::TemperatureRequest, ::WeatherService::TemperatureResponse
    end

    Stub = Service.rpc_stub_class
  end
end
