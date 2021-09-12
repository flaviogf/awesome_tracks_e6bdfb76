# frozen_string_literal: true

require 'sinatra/base'

module AwesomeTracksApi
  class Application < Sinatra::Application
    set :bind, '0.0.0.0'

    set :port, 3000

    get '/' do
      'Hey there!!!'
    end
  end
end
