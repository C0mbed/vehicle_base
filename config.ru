require 'sinatra'
require './config/environment'

use Rack::MethodOverride

use VehicleController
run UserController