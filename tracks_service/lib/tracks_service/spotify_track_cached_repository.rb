# frozen_string_literal: true

module TracksService
  class SpotifyTrackCachedRepository
    include Result::Methods

    def initialize(repository:, cache:, logger:)
      @repository = repository
      @cache = cache
      @logger = logger
    end

    def track_by_theme(theme)
      track_as_json = @cache.get(theme)

      return success(Models::Track.from_json(track_as_json)) unless track_as_json.nil?

      result = @repository.track_by_theme(theme)

      return failure("could not get track for theme: #{theme}") if result.failure?

      track = result.value

      @cache.set(theme, track.to_json, ex: 60 * 30)

      success(track)
    rescue StandardError => e
      @logger.error(e)

      failure("could not get track for theme: #{theme}")
    end
  end
end
