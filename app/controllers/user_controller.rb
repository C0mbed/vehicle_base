require_relative '../../config/environment'

class UserController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
    set layout: true
  end

  get '/' do
    session.clear
    erb :'user/login'
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

  get '/user/create' do
    erb :'user/create'
  end

  post '/user/create' do
    @user = User.new(name: params[:name], email: params[:login], password: params[:password])
    @user.save
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/vehicles'
    else
      erb :'user/authorize'
    end
  end

  get '/user/:id' do
    @user = User.find(params[:id])
    if current_user.id == @user.id
      erb :'user/show'
    else
      erb :'user/authorize'
    end
  end

  get '/user/:id/edit' do
    @user = User.find(params[:id])
    if current_user.id == @user.id
      erb :'user/edit'
    else
      erb :'user/authorize'
    end
  end

  patch '/user/:id/edit' do
    original_user = User.find(params[:id])
    if current_user.id == original_user.id && original_user.authenticate(params[:old_password])
      original_user.update(name: params[:name], email: params[:login], password: params[:new_password])

      redirect '/vehicles'
    else
      erb :'user/authorize'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end
end