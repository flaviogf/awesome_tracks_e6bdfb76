# frozen_string_literal: true

RSpec.describe WeatherService do
  describe '.temperature' do
    context 'when cache does not connect' do
      subject! do
        allow(described_class).to receive(:logger).and_return(logger)
        allow(described_class).to receive(:cache).and_raise(StandardError)
        described_class.temperature(request)
      end

      let(:request) { Request.new(city) }

      let(:city) { Faker::Address.city }

      let(:logger) do
        logger = double('logger')
        allow(logger).to receive(:error)
        logger
      end

      it { is_expected.to be_nil }

      it { expect(logger).to have_received(:error).once }
    end
  end
end

Request = Struct.new(:city)
