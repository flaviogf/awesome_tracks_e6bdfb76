# frozen_string_literal: true

module WeatherService
  Response = Struct.new(:status, :body)

  RSpec.describe OpenWeatherMapRepository do
    describe '#temperature_by_city' do
      context 'when pass city' do
        subject { described_class.new(client: client).temperature_by_city('franca') }

        let(:client) do
          double('client', get: ok)
        end

        let(:ok) do
          Response.new(200, body)
        end

        let(:internal_server_error) do
          Response.new(500, body)
        end

        let(:body) do
          File.read(File.join(File.expand_path(__dir__), 'fixtures', 'open_weather_map_campinas_200'))
        end

        it { is_expected.to be_a(Float) }

        context 'when service is not available' do
          let(:client) do
            double('client', get: internal_server_error)
          end

          it { is_expected.to be_nil }
        end
      end
    end
  end
end
