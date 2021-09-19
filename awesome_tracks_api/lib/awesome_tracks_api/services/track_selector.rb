# frozen_string_literal: true

module AwesomeTracksApi
  module Services
    class TrackSelector
      include Result::Methods

      def self.call(
        request,
        theme_selector: ThemeSelector.new,
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
        temperature_result = temperature_result_from(@request.fetch('city'))

        return failure('could not get temperature') if temperature_result.failure?

        track_result = track_result_from(theme_from(temperature_result.value))

        return failure('could not get track') if track_result.failure?

        success(track_result.value)
      end

      private

      def temperature_result_from(city)
        @weather_repository.temperature(city: city)
      end

      def theme_from(temperature)
        @theme_selector.call(temperature)
      end

      def track_result_from(theme)
        @track_repository.track(theme: theme)
      end
    end
  end
end
