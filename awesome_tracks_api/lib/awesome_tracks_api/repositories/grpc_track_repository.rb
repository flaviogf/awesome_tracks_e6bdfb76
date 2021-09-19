# frozen_string_literal: true

this_dir = File.expand_path(__dir__)

$LOAD_PATH.unshift(this_dir) unless $LOAD_PATH.include?(this_dir)

require 'tracks_service_pb'
require 'tracks_service_services_pb'

module AwesomeTracksApi
  module Repositories
    class GRPCTrackRepository
      include Result::Methods

      def track(request)
        stub = TracksService::Service::Stub.new('tracks_service:3000', :this_channel_is_insecure)

        result = stub.track(TracksService::TrackRequest.new(theme: request.fetch(:theme)))

        return failure(result.error) unless result.success

        success(result.value)
      rescue StandardError => e
        failure(e.message)
      end
    end
  end
end
