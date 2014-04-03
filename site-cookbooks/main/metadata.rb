name              'main'
maintainer        'Leonel Galán'
maintainer_email  'leonel@smashingboxes.com'
version           '0.0.1'

recipe 'main', 'Sets up Ruby on Rails'

depends 'user'
depends 'rbenv'
depends 'ruby_build'
depends 'nginx'
depends 'unicorn'
depends 'database'

supports 'ubuntu'
