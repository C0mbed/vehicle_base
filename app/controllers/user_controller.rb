require_relative '../../config/environment'

class UserController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    #set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
    set layout: true
    use Rack::Session::Cookie, :key => 'rack.session',
        :path => '/',
        :expire_after => 1200, # In seconds
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

  get '/user/create' do
    erb :'user/create'
  end

  post '/user/create' do
    @user = User.create(name: params[:name], email: params[:login], password: params[:password])
    #@user.save
    redirect '/vehicles/new'
  end


end