class ApplicationController < Sinatra::Base
    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "vehicle_base"
    end

    get '/' do
        erb :home
    end

    post '/login' do
        binding.pry
    end

    post '/sign_up' do
        binding.pry
    end
end