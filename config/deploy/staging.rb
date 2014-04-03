set :user, 'deployer'

server '127.0.0.1:2222', user: fetch(:user), roles: %w(web app)

# You can set custom ssh options globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
