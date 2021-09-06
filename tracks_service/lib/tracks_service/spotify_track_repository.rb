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

      tracks = body.fetch('tracks')

      items = Array(tracks.fetch('items'))

      track = items.first

      success(track)
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
  end
end
