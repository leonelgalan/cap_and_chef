server '127.0.0.1:2222', user: fetch(:deploy_user), roles: %w(web app db)

# You can set custom ssh options globally
set :ssh_options, {
  forward_agent: true,
}
