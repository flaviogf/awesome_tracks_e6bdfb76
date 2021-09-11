# frozen_string_literal: true

require 'base64'
require 'faraday'
require 'json'
require 'logger'
require 'redis'
require 'tracks_service/result'
require 'tracks_service/models'
require 'tracks_service/spotify_track_repository'
require 'tracks_service/spotify_track_cached_repository'

module TracksService
  class << self
    include Result::Methods

    def track(request)
      cached_repository.track_by_theme(request.theme)
    rescue StandardError => e
      logger.error(e)

      failure(e.message)
    end

    private

    def cached_repository
      SpotifyTrackCachedRepository.new(repository: repository, cache: cache, logger: logger)
    end

    def repository
      SpotifyTrackRepository.new(client: client, logger: logger)
    end

    def client
      Faraday.new(request: { timeout: 5 }) { |f| f.use Faraday::Response::RaiseError }
    end

    def logger
      Logger.new($stdout)
    end

    def cache
      Redis.new(host: 'cache', timeout: 5)
    end
  end
end
