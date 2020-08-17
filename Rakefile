ENV['SINATRA_ENV'] ||= 'development'

require_relative './config/environment'
require 'sinatra/activerecord/rake'
require './app/controllers/user_controller'

desc 'Console'
task :console do
    Pry.start
end