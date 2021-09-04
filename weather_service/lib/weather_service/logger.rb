# frozen_string_literal: true

require 'logger'

module WeatherService
  class Logger
    def initialize
      @logger = ::Logger.new($stdout)
    end

    def info(*args)
      @logger.info(*args)
      nil
    end

    def error(*args)
      @logger.error(*args)
      nil
    end
  end
end
