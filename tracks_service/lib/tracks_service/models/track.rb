# frozen_string_literal: true

module TracksService
  module Models
    class Track
      def initialize(id, name, url, album, artists)
        @id = id
        @name = name
        @url = url
        @album = album
        @artists = artists
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
