set :stage, :staging
set :branch, 'main'
set :rbenv_ruby, '2.6.6'

set :rails_env, :staging
set :environment, 'staging'
# whether we're using ssl or not, used for building nginx
# config file
set :enable_ssl, false

server '13.213.61.234', user: 'ubuntu', roles: %w{app db web}
