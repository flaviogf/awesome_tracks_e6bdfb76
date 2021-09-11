# frozen_string_literal: true

module TracksService
  RSpec.describe SpotifyTrackCachedRepository do
    describe '#track_by_theme' do
      subject(:cached_repository) { described_class.new(repository: repository, cache: cache) }

      let(:repository) { double('repository') }

      let(:cache) { double('cache') }

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
          expect(cache).to have_received(:set).with(theme, track.to_json).once
        end
      end
    end
  end
end
