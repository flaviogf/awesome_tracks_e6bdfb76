# frozen_string_literal: true

module TracksService
  RSpec.describe SpotifyTrackCachedRepository do
    describe '#track_by_theme' do
      subject(:cached_repository) { described_class.new(repository: repository, cache: cache, logger: logger) }

      let(:repository) { double('repository') }

      let(:cache) { double('cache') }

      let(:logger) { double('logger') }

      let(:theme) { Faker::Music.album }

      let(:track) do
        Models::Track.new(
          Faker::Internet.uuid,
          Faker::Music.album,
          Faker::Internet.url,
          album,
          artists
        )
      end

      let(:album) do
        Models::Album.new(
          Faker::Internet.uuid,
          Faker::Music.album,
          Faker::Internet.url,
          Faker::Internet.url
        )
      end

      let(:artists) do
        [
          Models::Artist.new(
            Faker::Internet.uuid,
            Faker::Name.name,
            Faker::Internet.url
          )
        ]
      end

      before do
        allow(repository).to receive(:track_by_theme).and_return(Result::Methods.success(track))
        allow(cache).to receive(:get)
        allow(cache).to receive(:set).and_return('OK')
      end

      it 'returns succeeded result' do
        result = cached_repository.track_by_theme(theme)
        expect(result.success?).to be_truthy
      end

      it 'returns a track' do
        result = cached_repository.track_by_theme(theme)

        expect(result.value).to eq(track)
      end

      context 'when cache was not hit' do
        it 'calls cache to try to get the track' do
          cached_repository.track_by_theme(theme)
          expect(cache).to have_received(:get).with(theme).once
        end

        it 'calls the repository to get the track' do
          cached_repository.track_by_theme(theme)
          expect(repository).to have_received(:track_by_theme).with(theme).once
        end

        it 'calls cache to set the founded track' do
          cached_repository.track_by_theme(theme)
          expect(cache).to have_received(:set).with(theme, track.to_json, ex: 60 * 30).once
        end
      end

      context 'when cache was hit' do
        before do
          allow(cache).to receive(:get).and_return(track.to_json)
        end

        it 'returns succeeded result' do
          result = cached_repository.track_by_theme(theme)
          expect(result.success?).to be_truthy
        end

        it 'returns the expected track' do
          result = cached_repository.track_by_theme(theme)
          expect(result.value).to eq(track)
        end

        it 'calls cache to try to get the track' do
          cached_repository.track_by_theme(theme)
          expect(cache).to have_received(:get).with(theme).once
        end

        it 'does not call the repository to get the track' do
          cached_repository.track_by_theme(theme)
          expect(repository).not_to have_received(:track_by_theme)
        end

        it 'does not call the cache to set the founded track' do
          cached_repository.track_by_theme(theme)
          expect(cache).not_to have_received(:set)
        end
      end

      context 'when repository returns failed result' do
        before do
          allow(repository).to receive(:track_by_theme).and_return(Result::Methods.failure('oops'))
        end

        it 'returns failed result' do
          result = cached_repository.track_by_theme(theme)
          expect(result.failure?).to be_truthy
        end
      end

      context 'when something goes wrong' do
        before do
          allow(cache).to receive(:get).and_raise(StandardError.new('oops'))
          allow(logger).to receive(:error)
        end

        it 'returns failed result' do
          result = cached_repository.track_by_theme(theme)
          expect(result.failure?).to be_truthy
        end

        it 'calls logger to record error' do
          cached_repository.track_by_theme(theme)
          expect(logger).to have_received(:error).once
        end
      end
    end
  end
end
