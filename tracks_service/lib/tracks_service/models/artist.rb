# frozen_string_literal: true

module TracksService
  module Models
    class Artist
      def initialize(id, name, url)
        @id = id
        @name = name
        @url = url
      end

      def to_h
        {
          id: @id,
          name: @name,
          url: @url
        }
      end
    end
  end
end
