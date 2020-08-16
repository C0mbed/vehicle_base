require_relative '../../config/environment'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
    set layout: true
    binding.pry
  end

  get '/' do
    erb :login
    #fix and validate empty username or password - use ActiveRecord Validations
  end

    #validate users
  post '/login' do
    user = User.find_by(email: params[:login])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      binding.pry
      redirect "/vehicles"
    else
      redirect "/"
    end
  end

  post '/create' do
    erb :create
  end

    #Helper Method Current User && Is Logged in?
  get '/vehicles' do
    @vehicles = Vehicle.all
    @my_vehicles = @vehicles.select { |v| v.user_id == session[:user_id] }
    if @my_vehicles.length > 0
      erb :home
    else
      erb :new
    end
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
    redirect "/vehicles"
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  get '/vehicles/:id' do
    @vehicle = Vehicle.find(params[:id])

    erb :show
  end

  #change to get in both vehicles/:id and below
  post '/vehicles/:id/edit' do
    @vehicle = Vehicle.find(params[:id])

    erb :edit
  end

  patch '/vehicles/:id/edit' do
    #check current user against vehicle.user_id
    original_vehicle = Vehicle.find(params[:id])
    original_vehicle.update(year: params[:year], make: params[:make], model: params[:model], color: params[:color], vin: params[:vin])

    redirect "/vehicles"
  end


  delete '/vehicles/:id/delete' do
    #check current user against vehicle.user_id
    @vehicle = Vehicle.find(params[:id])
    @vehicle.destroy

    redirect '/vehicles'
  end

end