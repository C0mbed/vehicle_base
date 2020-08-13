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
      redirect "/home/vehicles"
    else
      redirect "/"
    end
  end

  post '/create' do
    erb :create
  end

  get '/home/vehicles' do
    @vehicles = Vehicle.all
    @my_vehicles = @vehicles.select { |v| v.user_id == session[:user_id] }

    erb :home
  end

  post '/home' do
    @user = User.new(name: params[:name], email: params[:login], password: params[:password])
    @user.save

    erb :home
  end

  get '/vehicles/new' do
    erb :new
  end

  post '/new' do
    @vehicle = Vehicle.create(params)
    @vehicle.user_id = session[:user_id]
    @vehicle.save
    redirect "home/vehicles/#{@vehicle.id}"
  end

  get 'home/vehicles/:id' do
    @vehicle = Vehicle.find(params[:id])
    binding.pry
    erb :show
  end

  get '/cars' do
    redirect '/home/vehicles'
  end

end