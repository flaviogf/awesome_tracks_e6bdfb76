# frozen_string_literal: true

module AwesomeTracksApi
  module Repositories
    class GRPCWeatherRepository
      include Result::Methods

      def temperature(request)
        success(request)
      end
    end
  end
end
