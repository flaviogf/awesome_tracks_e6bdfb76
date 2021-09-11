# frozen_string_literal: true

module TracksService
  module Models
    class Album
      def self.from_json(json)
        json = json.to_json if json.is_a?(Hash)
        json = JSON.parse(json)

        new(
          json.fetch('id'),
          json.fetch('name'),
          json.fetch('url'),
          json.fetch('image_url')
        )
      end

      def initialize(id, name, url, image_url)
        @id = id
        @name = name
        @url = url
        @image_url = image_url
      end

      attr_reader :id, :name, :url, :image_url

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
