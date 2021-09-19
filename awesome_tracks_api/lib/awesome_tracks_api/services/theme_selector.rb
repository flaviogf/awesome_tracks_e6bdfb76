# frozen_string_literal: true

module AwesomeTracksApi
  module Services
    class ThemeSelector
      def call(temperature)
        case temperature
        when 31..Float::INFINITY then 'party'
        when 15..30 then 'pop'
        when 10..14 then 'rock'
        else 'classic'
        end
      end
    end
  end
end
