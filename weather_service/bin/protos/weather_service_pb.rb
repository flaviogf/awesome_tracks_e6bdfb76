# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protos/weather_service.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("protos/weather_service.proto", :syntax => :proto3) do
    add_message "weather_service.TemperatureRequest" do
    end
    add_message "weather_service.TemperatureResponse" do
    end
  end
end

module WeatherService
  TemperatureRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("weather_service.TemperatureRequest").msgclass
  TemperatureResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("weather_service.TemperatureResponse").msgclass
end
