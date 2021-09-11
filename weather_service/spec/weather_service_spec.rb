# frozen_string_literal: true

RSpec.describe WeatherService do
  describe '.temperature' do
    let(:cached_repository) { double('cached_repository') }

    let(:logger) { double('logger') }

    let(:request) { Request.new(city) }

    let(:city) { Faker::Address.city }

    let(:result) { WeatherService::Result::Methods.success('OK') }

    before do
      allow(described_class).to receive(:cached_repository).and_return(cached_repository)
      allow(described_class).to receive(:logger).and_return(logger)
      allow(cached_repository).to receive(:temperature_by_city).and_return(result)
      allow(logger).to receive(:error)
    end

    it 'returns succeeded result' do
      result = described_class.temperature(request)
      expect(result.success?).to be_truthy
    end

    context 'when something goes wrong' do
      before do
        allow(described_class).to receive(:cached_repository).and_raise(StandardError.new('oops'))
      end

      it 'returns failed result' do
        result = described_class.temperature(request)
        expect(result.failure?).to be_truthy
      end

      it 'calls logger to record an error' do
        described_class.temperature(request)
        expect(logger).to have_received(:error).once
      end
    end
  end
end

Request = Struct.new(:city)
