require 'uri'
require 'pathname'

require 'pg'
require 'active_record'
require 'logger'

require 'sinatra'
require "sinatra/reloader" if development?

# Include all of ActiveSupport's core class extensions, e.g., String#camelize
require 'active_support/core_ext'

# Some helper constants for path-centric logic
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
APP_NAME = APP_ROOT.basename.to_s

# Time.zone = 'Eastern Time (US & Canada)'
# ActiveRecord::Base.time_zone_aware_attributes = true
# ActiveRecord::Base.default_timezone = :local
# ActiveRecord::Base.logger = Logger.new(STDOUT)

configure do
  # By default, Sinatra assumes that the root is the file that calls the configure block.
  # Since this is not the case for us, we set it manually.
  set :root, APP_ROOT.to_path
  set :views, settings.root + '/app/views'


  #### set up your own logger ####
  # set :logging, nil
  # logger = Logger.new STDOUT
  # logger.level = Logger::INFO
  # logger.datetime_format = '%a %d-%m-%Y %H%M '
  # set :logger, logger
  ####
end

##########
# Automatically load every file in APP_ROOT/app/models/*.rb, e.g.,
#   autoload "Person", 'app/models/person.rb'
#
# See http://www.rubyinside.com/ruby-techniques-revealed-autoload-1652.html
##########
Dir[APP_ROOT.join('app', 'models', '*.rb'), 
    APP_ROOT.join('config', 'database.rb'),
    APP_ROOT.join('app', 'routes', '*.rb')].each do |file|
  filename = File.basename(file).gsub('.rb', '')
  autoload ActiveSupport::Inflector.camelize(filename), file
end
AppConfig.env = Sinatra::Application.environment
