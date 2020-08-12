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
    user = User.find_by(email: params[:login])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/home"
    else
      redirect "/"
    end
  end

  post '/create' do
    erb :create
  end

  get '/home' do
    erb :home
  end

  post '/home' do
    @user = User.new(name: params[:name], email: params[:login], password: params[:password])
    @user.save
    binding.pry
    erb :home
  end

  get '/new' do
    erb :new
  end

  post '/new' do
    @vehicle =
  end


end