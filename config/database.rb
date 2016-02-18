require 'yaml'

# Automatically load every file in APP_ROOT/app/models/*.rb, e.g.,
#   autoload "Person", 'app/models/person.rb'
#
# We have to do this in case we have models that inherit from each other.
# If model Student inherits from model Person and app/models/student.rb is
# required first, it will throw an error saying "Person" is undefined.
#
# With this lazy-loading technique, Ruby will try to load app/models/person.rb
# the first time it sees "Person" and will only throw an exception if
# that file doesn't define the Person class.
#
# See http://www.rubyinside.com/ruby-techniques-revealed-autoload-1652.html

db = YAML.load_file('config/database.yml')
db_settings = db[Sinatra::Application.environment.to_s]

ActiveRecord::Base.establish_connection(
  :adapter => db_settings['adapter'],
  :username => db_settings['username'],
  :host => db_settings['host'],
  :database => db_settings['database'],
  :pool => db_settings['pool'],
  :encoding => db_settings['encoding']
)

#DB_NAME = db_settings['database']

# Heroku controls what database we connect to by setting the DATABASE_URL environment variable
# We need to respect that if we want our Sinatra apps to run on Heroku without modification
# Not using the below because we are not using Heroku
### db = URI.parse(ENV['DATABASE_URL'] || "postgres://localhost/#{APP_NAME}_#{Sinatra::Application.environment}")
### DB_NAME = db.path[1..-1]

# Note:
#   Sinatra::Application.environment is set to the value of ENV['RACK_ENV']
#   if ENV['RACK_ENV'] is set.  If ENV['RACK_ENV'] is not set, it defaults
#   to :development

# ActiveRecord::Base.establish_connection(
#   :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
#   :host     => db.host,
#   :port     => db.port,
#   :username => db.user,
#   :password => db.password,
#   :database => DB_NAME,
#   :encoding => 'utf8'
# )