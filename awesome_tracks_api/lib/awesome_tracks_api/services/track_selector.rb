# frozen_string_literal: true

module AwesomeTracksApi
  module Services
    class TrackSelector
      include Result::Methods

      def self.call(
        request,
        theme_selector: nil,
        weather_repository: Repositories::GRPCWeatherRepository.new,
        track_repository: Repositories::GRPCTrackRepository.new
      )
        new(request, theme_selector, weather_repository, track_repository).call
      end

      def initialize(request, theme_selector, weather_repository, track_repository)
        @request = request
        @theme_selector = theme_selector
        @weather_repository = weather_repository
        @track_repository = track_repository
      end

      def call
        temperature_result = @weather_repository.temperature(city: @request.fetch('city'))

        return failure('could not get temperature') if temperature_result.failure?

        track_result = @track_repository.track(theme: fetch_theme_by(temperature_result.value))

        return failure('could not get track') if track_result.failure?

        track = track_result.value

        success(track)
      end

      private

      def fetch_theme_by(temperature)
        @theme_selector.call(temperature)
      end
    end
  end
end
