# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks
load 'neo4j/tasks/migration.rake'
load 'neo4j/tasks/neo4j_server.rake'

