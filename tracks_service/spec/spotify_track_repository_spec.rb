# frozen_string_literal: true

module TracksService
  Response = Struct.new(:status, :body)

  RSpec.describe SpotifyTrackRepository do
    subject(:repository) { described_class.new(client) }

    let(:client) { double('client') }

    let(:request) { double('request') }

    let(:theme) { Faker::Music.album }

    let(:track) { File.read(File.join(File.expand_path(__dir__), 'fixtures', 'spotify_search_party_track_200')) }

    let(:token) { File.read(File.join(File.expand_path(__dir__), 'fixtures', 'spotify_token_200')) }

    before do
      allow(request).to receive(:headers).and_return({})

      allow(client).to receive(:get) do |&block|
        block.call(request)
      end.and_return(Response.new(200, token), Response.new(200, track))
    end

    describe '#track_by_theme' do
      it 'returns succeeded result' do
        result = repository.track_by_theme(theme)
        expect(result.success?).to be_truthy
      end
    end
  end
end
