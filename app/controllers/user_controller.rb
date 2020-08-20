require_relative '../../config/environment'
require 'sinatra'
require 'sinatra/flash'

class UserController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
    set layout: true
    register Sinatra::Flash
  end

  get '/' do
    erb :'user/login'
  end

  post '/login' do
    @user = User.find_by(email: params[:login])
    if @user&.authenticate(params[:password])
      flash[:notice] = ''
      session[:user_id] = @user.id
      redirect '/vehicles'
    elsif @user.nil?
      flash[:error] = "#{params[:login]} not found, please create a new account"
      redirect '/'
    else
      flash[:error] = 'incorrect email or password'
      redirect '/'
    end
  end

  get '/user/create' do
    erb :'user/create'
  end

  post '/user/create' do
    @user = User.new(name: params[:name], email: params[:login], password: params[:password])
    if @user.save == true
      flash[:notice] = 'Account successfully created, please login'
      redirect '/'
    else
      flash[:error] = 'all fields required for account creation'
      redirect '/user/create'
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
      flash[:notice] = 'account successfully updated'

      redirect '/vehicles'
    else
      flash[:error] = 'old password is incorrect'
      redirect "/user/#{current_user.id}/edit"
    end
  end

  get '/logout' do
    session.clear
    flash[:notice] = 'successfully logged out'
    redirect '/'
  end
end
