# frozen_string_literal: true

module AwesomeTracksApi
  module Services
    RSpec.describe TrackSelector do
      describe '#call' do
        let(:track_repository) { instance_double('track_repository') }

        let(:request) do
          {
            'city' => Faker::Address.city
          }
        end

        let(:track) do
          {
            'id' => Faker::Internet.uuid
          }
        end

        before do
          allow(track_repository).to receive(:track).and_return(Result::Methods.success(track))
        end

        it 'returns success' do
          result = described_class.call(request, track_repository: track_repository)
          expect(result.success?).to be_truthy
        end

        it 'returns a track' do
          result = described_class.call(request, track_repository: track_repository)

          expected_track = {
            'id' => track.fetch('id')
          }

          track = result.value

          expect(track).to eq(expected_track)
        end

        context 'when repository returns failure result' do
          before do
            allow(track_repository).to receive(:track).and_return(Result::Methods.failure('oops'))
          end

          it 'returns failure result too' do
            result = described_class.call(request, track_repository: track_repository)
            expect(result.failure?).to be_truthy
          end
        end
      end
    end
  end
end
