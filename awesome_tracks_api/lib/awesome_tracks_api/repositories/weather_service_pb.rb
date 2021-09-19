# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: weather_service.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("weather_service.proto", :syntax => :proto3) do
    add_message "weather_service.TemperatureRequest" do
      optional :city, :string, 1
    end
    add_message "weather_service.TemperatureResponse" do
      optional :success, :bool, 1
      proto3_optional :value, :float, 2
      proto3_optional :error, :string, 3
    end
  end
end

module WeatherService
  TemperatureRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("weather_service.TemperatureRequest").msgclass
  TemperatureResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("weather_service.TemperatureResponse").msgclass
end