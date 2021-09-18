# frozen_string_literal: true

module AwesomeTracksApi
  module Repositories
    class GRPCTrackRepository
      include Result::Methods

      def track(request)
        success(request)
      end
    end
  end
end
