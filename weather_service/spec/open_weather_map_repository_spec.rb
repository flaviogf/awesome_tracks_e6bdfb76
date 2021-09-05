# frozen_string_literal: true

module WeatherService
  Response = Struct.new(:status, :body)

  RSpec.describe OpenWeatherMapRepository do
    describe '#temperature_by_city' do
      context 'when pass city' do
        subject! { described_class.new(client: client, logger: logger).temperature_by_city(city) }

        let(:client) { double('client', get: response) }

        let(:logger) { double('logger', error: nil) }

        let(:city) { Faker::Address.city }

        let(:response) { Response.new(200, body) }

        let(:body) { File.read(File.join(File.expand_path(__dir__), 'fixtures', 'open_weather_map_campinas_200')) }

        it { is_expected.to be_a(Float) }

        context 'when something goes wrong' do
          let(:client) do
            client = double('client')
            allow(client).to receive(:get).and_raise(StandardError)
            client
          end

          it { is_expected.to be_nil }

          it { expect(logger).to have_received(:error).once }
        end
      end
    end
  end
end
