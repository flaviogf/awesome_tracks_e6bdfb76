# frozen_string_literal: true

module TracksService
  class SpotifyTrackRepository
    include Result::Methods

    SPOTIFY_API_CLIENT_ID = ENV.fetch('SPOTIFY_API_CLIENT_ID', '').freeze
    SPOTIFY_API_CLIENT_SECRET = ENV.fetch('SPOTIFY_API_CLIENT_SECRET', '').freeze

    def initialize(client:, logger:)
      @client = client
      @logger = logger
    end

    def track_by_theme(theme)
      url = "https://api.spotify.com/v1/search?query=#{theme}&type=track&offset=0&limit=1"

      response = @client.get(url) { |req| req.headers['Authorization'] = "Bearer #{access_token}" }

      body = JSON.parse(response.body)

      hashes = Array(body.fetch('tracks').fetch('items'))

      hash = hashes.first

      success(track(hash))
    rescue StandardError => e
      @logger.error(e)

      failure("could not get track for theme: #{theme}")
    end

    private

    def access_token
      api_key = Base64.strict_encode64("#{SPOTIFY_API_CLIENT_ID}:#{SPOTIFY_API_CLIENT_SECRET}")

      url = 'https://accounts.spotify.com/api/token'

      response = @client.get(url) { |req| req.headers['Authorization'] = "Basic #{api_key}" }

      body = JSON.parse(response.body)

      body.fetch('access_token')
    end

    def track(hash)
      Models::Track.new(
        hash.fetch('id'),
        hash.fetch('name'),
        hash.fetch('external_urls').fetch('spotify'),
        album(hash),
        Array(hash.fetch('artists')).map(&method(:artist))
      )
    end

    def artist(hash)
      Models::Artist.new(
        hash.fetch('id'),
        hash.fetch('name'),
        hash.fetch('external_urls').fetch('spotify')
      )
    end

    def album(hash)
      Models::Album.new(
        hash.fetch('album').fetch('id'),
        hash.fetch('album').fetch('name'),
        hash.fetch('album').fetch('external_urls').fetch('spotify'),
        Array(hash.fetch('album').fetch('images')).first.fetch('url')
      )
    end
  end
end
