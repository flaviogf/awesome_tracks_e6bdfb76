# frozen_string_literal: true

module AwesomeTracksApi
  module Services
    RSpec.describe TrackSelector do
      describe '#call' do
        let(:theme_selector) { instance_double('theme_selector') }

        let(:weather_repository) { instance_double('weather_repository') }

        let(:track_repository) { instance_double('track_repository') }

        let(:request) do
          {
            'city' => Faker::Address.city
          }
        end

        let(:temperature) do
          29.50
        end

        let(:track) do
          {
            'id' => Faker::Internet.uuid
          }
        end

        let(:theme) do
          Faker::Music.genre
        end

        before do
          allow(theme_selector).to receive(:call).and_return(theme)
          allow(weather_repository).to receive(:temperature).and_return(Result::Methods.success(temperature))
          allow(track_repository).to receive(:track).and_return(Result::Methods.success(track))
        end

        it 'returns success' do
          result = described_class.call(
            request,
            theme_selector: theme_selector,
            weather_repository: weather_repository,
            track_repository: track_repository
          )

          expect(result.success?).to be_truthy
        end

        it 'returns a track' do
          result = described_class.call(
            request,
            theme_selector: theme_selector,
            weather_repository: weather_repository,
            track_repository: track_repository
          )

          expected_track = {
            'id' => track.fetch('id')
          }

          track = result.value

          expect(track).to eq(expected_track)
        end

        it 'calls theme selector with the returned temperature to choose the correct theme' do
          described_class.call(
            request,
            theme_selector: theme_selector,
            weather_repository: weather_repository,
            track_repository: track_repository
          )

          expect(theme_selector).to have_received(:call).with(temperature).once
          expect(track_repository).to have_received(:track).with(theme: theme).once
        end

        context 'when weather repository returns failure result' do
          before do
            allow(weather_repository).to receive(:temperature).and_return(Result::Methods.failure('oops'))
          end

          it 'returns failure result too' do
            result = described_class.call(
              request,
              theme_selector: theme_selector,
              weather_repository: weather_repository,
              track_repository: track_repository
            )

            expect(result.failure?).to be_truthy
          end
        end

        context 'when track repository returns failure result' do
          before do
            allow(track_repository).to receive(:track).and_return(Result::Methods.failure('oops'))
          end

          it 'returns failure result too' do
            result = described_class.call(
              request,
              theme_selector: theme_selector,
              weather_repository: weather_repository,
              track_repository: track_repository
            )

            expect(result.failure?).to be_truthy
          end
        end
      end
    end
  end
end
