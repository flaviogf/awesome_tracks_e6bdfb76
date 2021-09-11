# frozen_string_literal: true

module TracksService
  module Models
    class Artist
      def self.from_json(json)
        json = json.to_json if json.is_a?(Hash)
        json = JSON.parse(json)

        new(
          json.fetch('id'),
          json.fetch('name'),
          json.fetch('url')
        )
      end

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
