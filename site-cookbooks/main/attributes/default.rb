default[:app][:user] = 'deployer'
default[:app][:user_group] = 'sudo'
default[:app][:rails_env] = 'production'
default[:ruby][:version] = '2.1.1'

default[:app][:name] = 'cap_and_chef'
default[:app][:deploy_to] = "/home/#{node[:app][:user]}/www/#{node[:app][:name]}"

default[:app][:unicorn][:user] = node[:app][:user]
default[:app][:unicorn][:pid] = "#{node[:app][:deploy_to]}/current/tmp/pids/unicorn.pid"
default[:app][:unicorn][:sock] = "/tmp/unicorn.#{node[:app][:name]}.sock"
default[:app][:unicorn][:config] = "#{node[:app][:deploy_to]}/shared/config/unicorn.rb"
default[:app][:unicorn][:log] = "#{node[:app][:deploy_to]}/shared/log/unicorn.log"
default[:app][:unicorn][:workers] = 2

default[:app][:postgresql][:host] = 'localhost'
default[:app][:postgresql][:user] = 'postgres'
default[:app][:postgresql][:password] = 'postgres'
default[:app][:postgresql][:database] = "#{node[:app][:name]}_#{node[:app][:rails_env]}"

# default[:rbenv][:rubies] = Array(node[:ruby][:version]),
# default[:rbenv][:global] = node[:ruby][:version],
# default[:rbenv][:gems] = {node[:ruby][:version] => [name: 'bundler']}
