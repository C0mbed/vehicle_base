require './config/environment'

use Rack::MethodOverride
Dir[File.join(File.dirname(__FILE__), 'app/controllers', '*.rb')].collect {|file| File.basename(file).split('.')[0] }.reject {|file| file == 'application_controller' }.each do |file|
  string_class_name = file.split('_').collect(&:capitalize).join
  class_name = Object.const_get(string_class_name)
  use class_name
end

use VehicleController
run UserController