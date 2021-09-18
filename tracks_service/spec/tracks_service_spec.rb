# frozen_string_literal: true

RSpec.describe TracksService do
  describe '.track' do
    let(:cached_repository) { double('cached_repository') }

    let(:logger) { double('logger') }

    let(:request) { Request.new(theme: theme) }

    let(:theme) { Faker::Music.album }

    let(:result) { described_class::Result::Methods.success('OK') }

    before do
      allow(described_class).to receive(:cached_repository).and_return(cached_repository)
      allow(described_class).to receive(:logger).and_return(logger)
      allow(cached_repository).to receive(:track_by_theme).and_return(result)
      allow(logger).to receive(:error)
    end

    it 'returns succeeded result' do
      result = described_class.track(request)
      expect(result.success?).to be_truthy
    end

    context 'when something goes wrong' do
      before do
        allow(described_class).to receive(:cached_repository).and_raise(StandardError.new('oops'))
      end

      it 'returns failed result' do
        result = described_class.track(request)
        expect(result.failure?).to be_truthy
      end

      it 'calls logger to record an error' do
        described_class.track(request)
        expect(logger).to have_received(:error).once
      end
    end
  end
end

Request = Struct.new(:theme)
