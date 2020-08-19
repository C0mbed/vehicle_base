require_relative '../../config/environment'

class VehicleController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
    set layout: true
  end

  get '/vehicles' do
    if logged_in?
      @my_vehicles = Vehicle.where(user_id: session[:user_id])
      if @my_vehicles.length > 0
        erb :'vehicle/home'
      else
        erb :'vehicle/new'
      end
    else
      erb :'user/authorize'
    end
  end

  get '/vehicles/new' do
    erb :'vehicle/new'
  end

  post '/vehicles/new' do
    @vehicle = Vehicle.create(params)
    @vehicle.user_id = session[:user_id]
    @vehicle.save
    redirect '/vehicles'
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
    if current_user.id == @vehicle.user_id
      @vehicle.destroy

      redirect '/vehicles'
    else
      erb :'user/authorize'
    end
  end

end