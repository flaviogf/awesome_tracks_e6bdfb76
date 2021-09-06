# frozen_string_literal: true

module WeatherService
  RSpec.describe OpenWeatherMapCachedRepository do
    describe '.temperature_by_city' do
      context 'when pass city' do
        subject(:cached_repository) { described_class.new(repository: repository, cache: cache, logger: logger) }

        let(:repository) { double('repository', temperature_by_city: Result::Methods.success(temperature)) }

        let(:cache) { double('cache', set: 'OK', get: nil) }

        let(:logger) { double('logger', error: nil) }

        let(:city) { Faker::Address.city }

        let(:temperature) { 294.46 }

        it 'returns succeeded result' do
          result = cached_repository.temperature_by_city(city)
          expect(result.success?).to be_truthy
        end

        it 'returns float' do
          result = cached_repository.temperature_by_city(city)
          expect(result.value).to be_a(Float)
        end

        context 'when repository returns failed result' do
          let(:repository) { double('repository', temperature_by_city: Result::Methods.failure('oops')) }

          it 'returns failed result' do
            result = cached_repository.temperature_by_city(city)
            expect(result.failure?).to be_truthy
          end
        end

        context 'when something goes wrong' do
          let(:cache) do
            cache = double('cache')
            allow(cache).to receive(:get).and_raise(StandardError)
            cache
          end

          it 'calls logger to record an error' do
            cached_repository.temperature_by_city(city)
            expect(logger).to have_received(:error).once
          end
        end

        context 'when cache was not hit' do
          it 'calls repository to get the temperature' do
            cached_repository.temperature_by_city(city)
            expect(repository).to have_received(:temperature_by_city).with(city).once
          end

          it 'calls cache to try to get the the temperature' do
            cached_repository.temperature_by_city(city)
            expect(cache).to have_received(:get).with(city).once
          end

          it 'calls cache to record the temperature' do
            cached_repository.temperature_by_city(city)
            expect(cache).to have_received(:set).with(city, temperature, { ex: 60 * 30 }).once
          end
        end

        context 'when cache was hit' do
          let(:cache) { double('cache', set: 'OK', get: temperature) }

          it 'does not call repository to get the temperature' do
            cached_repository.temperature_by_city(city)
            expect(repository).not_to have_received(:temperature_by_city).with(city)
          end

          it 'calls cache to try to get the the temperature' do
            cached_repository.temperature_by_city(city)
            expect(cache).to have_received(:get).with(city).once
          end

          it 'does not call cache to record the temperature' do
            cached_repository.temperature_by_city(city)
            expect(cache).not_to have_received(:set).with(city, temperature, { ex: 60 * 30 })
          end
        end
      end
    end
  end
end
