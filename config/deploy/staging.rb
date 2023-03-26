set :stage, :staging
# set :branch, 'set-up-ci-cd'
set :branch, 'main'
set :rbenv_ruby, '2.6.6'

set :rails_env, :staging
set :environment, 'staging'
# whether we're using ssl or not, used for building nginx
# config file
set :enable_ssl, false

server '18.136.207.28', user: 'ubuntu', roles: %w{app db web runner}
