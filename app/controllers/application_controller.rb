require_relative '../../config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    #set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
    set layout: true
    use Rack::Session::Cookie, :key => 'rack.session',
        :path => '/',
        :expire_after => 2592000, # In seconds
        :secret => "6dd501044121ee37f33d691bc79c672c0c4d0c34ad3ceebac5d1b658542f621cfba2f01a718e6164441705d74c934b29b4e2fa9b8e9b3278df38534182b15e21"

  end

  get '/' do
    if logged_in?
      redirect '/vehicles'
    else
      erb :'user/login'
    end
  end

  post '/login' do
    @user = User.find_by(email: params[:login])
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/vehicles'
    else
      erb :'user/authorize'
    end
  end

  post '/create' do
    erb :'user/create'
  end

  get '/vehicles' do
    if logged_in?
      @vehicles = Vehicle.all
      @my_vehicles = @vehicles.select { |v| v.user_id == session[:user_id] }
      if @my_vehicles.length > 0
        erb :'vehicle/home'
      else
        erb :'vehicle/new'
      end
    else
      erb :'user/authorize'
    end
  end

  post '/home' do
    @user = User.new(name: params[:name], email: params[:login], password: params[:password])
    @user.save

    redirect '/vehicles/new'
  end

  get '/vehicles/new' do
    erb :'vehicle/new'
  end

  post '/new' do
    @vehicle = Vehicle.create(params)
    @vehicle.user_id = session[:user_id]
    @vehicle.save
    redirect '/vehicles'
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/vehicles/:id' do
    @vehicle = Vehicle.find(params[:id])
    if current_user.id == @vehicle.user_id
      erb :'vehicle/show'
    else
      erb :'user/authorize'
    end
  end

  get '/vehicles/:id/edit' do
    @vehicle = Vehicle.find(params[:id])

    erb :'vehicle/edit'
  end

  patch '/vehicles/:id/edit' do
    original_vehicle = Vehicle.find(params[:id])
    if current_user.id == original_vehicle.user_id
      original_vehicle.update(year: params[:year], make: params[:make], model: params[:model], color: params[:color], vin: params[:vin])

      redirect '/vehicles'
    else
      erb :'user/authorize'
    end
  end


  delete '/vehicles/:id/delete' do
    @vehicle = Vehicle.find(params[:id])
    if current_user.id == @vehicle.id
      @vehicle.destroy

      redirect '/vehicles'
    else
      erb :'user/authorize'
    end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id]) if session[:user_id]
    end
  end

end