# frozen_string_literal: true

module TracksService
  class SpotifyTrackCachedRepository
    include Result::Methods

    def initialize(repository:)
      @repository = repository
    end

    def track_by_theme(theme)
      result = @repository.track_by_theme(theme)
      success(result.value)
    end
  end
end
