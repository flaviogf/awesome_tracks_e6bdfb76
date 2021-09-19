# frozen_string_literal: true

module AwesomeTracksApi
  module Services
    class TrackSelector
      include Result::Methods

      def self.call(request, weather_repository: nil, track_repository: Repositories::GRPCTrackRepository.new)
        new(request, weather_repository, track_repository).call
      end

      def initialize(request, weather_repository, track_repository)
        @request = request
        @weather_repository = weather_repository
        @track_repository = track_repository
      end

      def call
        result = @track_repository.track(theme: 'rock')

        return failure('could not get track') unless result.success?

        track = result.value

        success(track)
      end
    end
  end
end
