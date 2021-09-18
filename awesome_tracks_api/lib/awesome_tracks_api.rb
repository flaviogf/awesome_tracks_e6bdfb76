# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/json'
require 'awesome_tracks_api/result'
require 'awesome_tracks_api/repositories'
require 'awesome_tracks_api/services'

module AwesomeTracksApi
  class Application < Sinatra::Application
    set :bind, '0.0.0.0'

    set :port, 3000

    set :public_folder, -> { File.join(File.expand_path(__dir__), 'awesome_tracks_api', 'static') }

    set :views, -> { File.join(File.expand_path(__dir__), 'awesome_tracks_api', 'views') }

    get '/' do
      erb :index
    end

    get '/tracks' do
      result = Services::TrackSelector.call(params)

      return json error: result.error if result.failure?

      json result.value
    end
  end
end
