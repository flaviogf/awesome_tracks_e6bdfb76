# frozen_string_literal: true

module TracksService
  class SpotifyTrackCachedRepository
    include Result::Methods

    def track_by_theme(theme)
      success(0)
    end
  end
end
