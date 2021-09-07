# frozen_string_literal: true

module TracksService
  module Models
    class Album
      def initialize(id, name, url, image_url)
        @id = id
        @name = name
        @url = url
        @image_url = image_url
      end

      def to_h
        {
          id: @id,
          name: @name,
          url: @url,
          image_url: @image_url
        }
      end
    end
  end
end
