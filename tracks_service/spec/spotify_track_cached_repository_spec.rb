# frozen_string_literal: true

module TracksService
  RSpec.describe SpotifyTrackCachedRepository do
    describe '#track_by_theme' do
      subject(:cached_repository) { described_class.new }

      let(:theme) { Faker::Music.album }

      it 'returns succeeded result' do
        result = cached_repository.track_by_theme(theme)
        expect(result.success?).to be_truthy
      end
    end
  end
end
