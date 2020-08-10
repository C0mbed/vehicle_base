require_relative '../../config/environment'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "vehicle_base"
    set layout: true
  end

  get '/' do
    erb :login
  end

  post '/login' do
    @user = User.find(email: params[:user_name], password: params[:password])
    session[:user_id] = @user.id
    binding.pry
  end

  post '/sign_up' do
    binding.pry
  end
end