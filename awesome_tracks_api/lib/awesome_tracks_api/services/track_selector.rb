# frozen_string_literal: true

module AwesomeTracksApi
  module Services
    class TrackSelector
      include Result::Methods

      def self.call(request, track_repository: Repositories::GRPCTrackRepository.new)
        new(request, track_repository).call
      end

      def initialize(request, track_repository)
        @request = request
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
