# Load DSL and Setup Up Stages
require 'capistrano/setup'
require "capistrano/deploy"
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git
require 'capistrano/rails'
require 'capistrano/rails/db'
require 'capistrano/bundler'
require 'capistrano/rvm'
require 'capistrano/puma'
require 'capistrano/rake'
require 'capistrano/delayed_job'
require "whenever/capistrano"
install_plugin Capistrano::Puma
# require 'capistrano/dotenv'

# require 'capistrano/sidekiq'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
