# frozen_string_literal: true

RSpec.describe WeatherService do
  describe '.temperature' do
    context 'when cache does not connect' do
      let(:request) { Request.new(city) }

      let(:city) { Faker::Address.city }

      let(:logger) { double('logger') }

      before do
        allow(logger).to receive(:error)
        allow(described_class).to receive(:logger).and_return(logger)
        allow(described_class).to receive(:cache).and_raise(StandardError.new('oops'))
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
