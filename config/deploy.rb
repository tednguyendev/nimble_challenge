# config valid for current version and patch releases of Capistrano
lock '~> 3.17.2'

set(:application, 'nimble-challenge-be')
set(:repo_url, 'git@github.com:tednguyendev/nimble_challenge.git')
set(:deploy_to, '/home/ubuntu/www/nimble-challenge/rails')
set(:assets_roles, %i[app db])
set(:rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec")
set(:rbenv_map_bins, %w[rake gem bundle ruby rails puma pumactl])
set(:default_env, { path: '~/.rbenv/shims:~/.rbenv/bin:$PATH' })
set(:format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto)
set :puma_bind, "0.0.0.0:3000"
# Default value for :pty is false
set(:keep_releases, 3)
# Default value for :linked_files is []
set(:linked_files, %w[.env])
set :log_lines, ENV['log_lines'] || 1000

append(
  :linked_dirs,
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'vendor/bundle',
  'public/system',
  'public/uploads',
)

# namespace :sidekiq do
#   task :restart do
#     # invoke 'sidekiq:stop'
#     invoke 'sidekiq:start'
#   end

#   before 'deploy:finished', 'sidekiq:restart'

#   task :stop do
#     on roles(:app) do
#       within current_path do
#         pid = p capture "ps aux | grep sidekiq | awk '{print $2}' | sed -n 1p"
#         execute("kill -9 #{pid}")
#       end
#     end
#   end

#   task :start do
#     on roles(:app) do
#       within current_path do
#         execute :bundle, "exec sidekiq -e #{fetch(:stage)} -C config/sidekiq.yml -d"
#       end
#     end
#   end
# end

# namespace :deploy do
#   desc 'restart application'
#   task :restart do
#     on roles(:app) do
#       invoke 'puma:stop'
#       invoke 'puma:start'
#     end
#   end
# end