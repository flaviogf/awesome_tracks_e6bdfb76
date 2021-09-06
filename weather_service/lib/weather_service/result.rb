# frozen_string_literal: true

module WeatherService
  class Result
    module Methods
      module_function

      def success(value)
        Result.new(success: true, value: value)
      end

      def failure(error)
        Result.new(success: false, error: error)
      end
    end

    def initialize(success:, error: nil, value: nil)
      @success = success
      @error = error
      @value = value
    end

    def success?
      @success
    end

    def failure?
      !@success
    end

    def error
      raise StandardError, 'error is nil' if @error.nil?

      @error
    end

    def value
      raise StandardError, 'value is nil' if @value.nil?

      @value
    end
  end
end
