# frozen_string_literal: true

module TracksService
  Response = Struct.new(:status, :body)

  RSpec.describe SpotifyTrackRepository do
    subject(:repository) { described_class.new(client: client, logger: logger) }

    let(:client) { double('client') }

    let(:logger) { double('loggger') }

    let(:request) { double('request') }

    let(:theme) { Faker::Music.album }

    let(:track) { File.read(File.join(File.expand_path(__dir__), 'fixtures', 'spotify_search_party_track_200')) }

    let(:token) { File.read(File.join(File.expand_path(__dir__), 'fixtures', 'spotify_token_200')) }

    before do
      allow(request).to receive(:headers).and_return({})

      allow(client).to receive(:post) do |&block|
        block.call(request)
      end.and_return(Response.new(200, token))

      allow(client).to receive(:get) do |&block|
        block.call(request)
      end.and_return(Response.new(200, track))

      allow(logger).to receive(:error)
    end

    describe '#track_by_theme' do
      it 'returns succeeded result' do
        result = repository.track_by_theme(theme)
        expect(result.success?).to be_truthy
      end

      it 'returns a track' do
        result = repository.track_by_theme(theme)

        items = Array(JSON.parse(track).dig('tracks', 'items'))

        item = items.first

        expected_hash = {
          id: item.fetch('id'),
          name: item.fetch('name'),
          url: item.fetch('external_urls').fetch('spotify'),
          album: {
            id: item.fetch('album').fetch('id'),
            name: item.fetch('album').fetch('name'),
            url: item.fetch('album').fetch('external_urls').fetch('spotify'),
            image_url: Array(item.fetch('album').fetch('images')).first.fetch('url')
          },
          artists: Array(item.fetch('artists')).map do |it|
            {
              id: it.fetch('id'),
              name: it.fetch('name'),
              url: it.fetch('external_urls').fetch('spotify')
            }
          end
        }

        value = result.value

        hash = value.to_h

        expect(expected_hash).to eq(hash)
      end

      context 'when something goes wrong' do
        before do
          allow(client).to receive(:get).and_raise(StandardError.new('oops'))
        end

        it 'returns failed result' do
          result = repository.track_by_theme(theme)
          expect(result.failure?).to be_truthy
        end

        it 'calls logger to record an error' do
          repository.track_by_theme(theme)
          expect(logger).to have_received(:error).once
        end
      end
    end
  end
end
