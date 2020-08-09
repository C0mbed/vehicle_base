class ApplicationController < Sinatra::Base
    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "vehicle_base"
    end

    get '/' do
        "It's Alive!"
    end
end