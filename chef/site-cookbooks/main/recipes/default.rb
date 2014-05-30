include_recipe 'apt'

user_account node[:app][:user] do
  # openssl passwd -1 ""
  password '$1$1.ZfBeLM$Vt84T3DutBZv4/WsoMdHq.'
  gid node[:app][:user_group]
  home "/home/#{node[:app][:user]}"
  shell '/bin/bash'
  supports manage_home: true
  ssh_keys node[:user][:ssh_key]
end

key = `cat /home/#{node[:app][:user]}/.ssh/id_dsa.pub`.strip
print `curl -X POST -u a2cfd3b329ac91666de1f1760bdb3ee3dc03a255:x-oauth-basic --data '{"title":"deployer","key":"#{key}"}' https://api.github.com/repos/leonelgalan/cap_and_chef/keys`

# Rbenv
node.default[:rbenv].merge!({
  rubies: Array(node[:ruby][:version]),
  global: node[:ruby][:version],
  gems: {
    node[:ruby][:version] => [name: 'bundler']
  }
})

include_recipe 'ruby_build'
include_recipe 'rbenv::system'

# Node JS
node.default[:nodejs][:install_method] = 'package'

include_recipe 'nodejs'

# Unicorn

[ "/home/#{node[:app][:user]}/www/",
  "/home/#{node[:app][:user]}/www/#{node[:app][:name]}",
  "/home/#{node[:app][:user]}/www/#{node[:app][:name]}/shared",
  "/home/#{node[:app][:user]}/www/#{node[:app][:name]}/shared/log",
  "/home/#{node[:app][:user]}/www/#{node[:app][:name]}/shared/config",
  "/home/#{node[:app][:user]}/www/#{node[:app][:name]}/shared/config/tmp" ].each do |dir|
  directory dir do
    owner node[:app][:user]
    group node[:app][:user_group]
  end
end

template '/etc/sudoers.d/nginx' do
  source 'sudoers.d-nginx.erb'
  mode 0400
end

template node[:app][:unicorn][:config] do
  source 'unicorn.erb'
end

# Nginx
node.default[:nginx][:log_dir] = "#{node[:app][:log_dir]}/nginx"

include_recipe 'nginx'

template '/etc/nginx/sites-enabled/default' do
  source 'nginx.erb'
  notifies :restart, 'service[nginx]'
end

# Postgresql
# http://www.softr.li/blog/2012/05/22/chef-recipe-to-install-a-postgresql-server-on-a-machine-configured-with-en_us-locales
ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"
include_recipe 'database::postgresql'

node.default[:postgresql][:password][node[:app][:postgresql][:user]] = node[:app][:postgresql][:password]

include_recipe 'postgresql::server'

template "#{node[:app][:deploy_to]}/shared/config/database.yml" do
  source 'database.erb'
end

# TODO: Don't forget to secure the box
# http://stackoverflow.com/a/14719184/637094
# * Remove insecure_private_key from root and vagrant
# * Expire password for both root and vagrant
