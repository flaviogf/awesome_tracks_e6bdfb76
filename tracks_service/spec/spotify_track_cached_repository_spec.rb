# frozen_string_literal: true

module TracksService
  RSpec.describe SpotifyTrackCachedRepository do
    describe '#track_by_theme' do
      subject(:cached_repository) { described_class.new(repository: repository) }

      let(:repository) { double('repository') }

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
      end

      it 'returns succeeded result' do
        result = cached_repository.track_by_theme(theme)
        expect(result.success?).to be_truthy
      end

      it 'returns a track' do
        result = cached_repository.track_by_theme(theme)

        expect(result.value).to eq(track)
      end
    end
  end
end
