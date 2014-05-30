# config valid only for Capistrano 3.1
lock '3.1.0'

# Troubleshoot
set :bundle_flags, '--deployment'
set :log_level, :debug

set :rbenv_type, :system
set :rbenv_ruby, '2.1.1'

set :application, 'cap_and_chef'
set :deploy_user, 'deployer'
set :repo_url, "git@github.com:leonelgalan/#{fetch :application}.git"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
puts "/home/#{fetch :deploy_user}/www/#{fetch :application}"
set :deploy_to, "/home/#{fetch :deploy_user}/www/#{fetch :application}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :unicorn_config_path, "#{fetch :deploy_to}/shared/config/unicorn.rb"
set :unicorn_rack_env, 'staging'

namespace :deploy do
  task :reload_unicorn do
    invoke 'unicorn:restart'
  end

  before :publishing, :migrate
  after :publishing, 'nginx:restart'
  after :publishing, :reload_unicorn
end
