# frozen_string_literal: true

module TracksService
  module Models
    class Track
      def self.from_json(json)
        json = json.to_json if json.is_a?(Hash)
        json = JSON.parse(json)

        new(
          json.fetch('id'),
          json.fetch('name'),
          json.fetch('url'),
          Album.from_json(json.fetch('album')),
          Array(json.fetch('artists')).collect(&Artist.method(:from_json))
        )
      end

      def initialize(id, name, url, album, artists)
        @id = id
        @name = name
        @url = url
        @album = album
        @artists = artists
      end

      def ==(other)
        to_json == other.to_json
      end

      def to_json(*args)
        to_h.to_json(*args)
      end

      def to_h
        {
          id: @id,
          name: @name,
          url: @url,
          album: @album.to_h,
          artists: @artists.collect(&:to_h)
        }
      end
    end
  end
end
