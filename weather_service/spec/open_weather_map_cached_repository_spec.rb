# frozen_string_literal: true

module WeatherService
  RSpec.describe OpenWeatherMapCachedRepository do
    describe '.temperature_by_city' do
      context 'when pass city' do
        subject! { described_class.new(repository: repository, cache: cache, logger: logger).temperature_by_city(city) }

        let(:repository) { double('repository', temperature_by_city: temperature) }

        let(:cache) { double('cache', set: 'OK', get: nil) }

        let(:logger) { double('logger', error: nil) }

        let(:city) { Faker::Address.city }

        let(:temperature) { 294.46 }

        it { is_expected.to be_a(Float) }

        context 'when something goes wrong' do
          let(:cache) do
            cache = double('cache')
            allow(cache).to receive(:get).and_raise(StandardError)
            cache
          end

          it { expect(logger).to have_received(:error).once }
        end

        context 'when cache was not hit' do
          it { expect(repository).to have_received(:temperature_by_city).with(city).once }

          it { expect(cache).to have_received(:get).with(city).once }

          it { expect(cache).to have_received(:set).with(city, temperature, { ex: 60 * 30 }).once }
        end

        context 'when cache was hit' do
          let(:cache) { double('cache', set: 'OK', get: temperature) }

          it { expect(repository).not_to have_received(:temperature_by_city) }

          it { expect(cache).to have_received(:get).with(city).once }

          it { expect(cache).not_to have_received(:set) }
        end
      end
    end
  end
end
