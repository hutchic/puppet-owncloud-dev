class owncloud-dev::from_source () {

  class { 'apache':
    mpm_module => prefork
  }
  include 'apache::mod::php'
  apache::vhost { 'owncloud.dev':
    port               => '80',
    docroot            => '/var/www/',
    directories        => [
      { path           => '/var/www/',
        allow_override => ['All'],
      },
    ]
  }

  php::module { [ 'gd', 'mysql' ]:
    require  => Class['php'],
  }

  include 'mysql::server'
  mysql::db { 'owncloud':
    user     => 'owncloud',
    password => 'ownclouddbpassword',
    host     => 'localhost',
    grant    => ['ALL'],
  }

  file { '/var/www':
    owner    => 'www-data',
    mode     => 655,
    group    => 'www-data',
    ensure   => directory,
  }

  include 'git'
  vcsrepo { '/var/www/owncloud':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/owncloud/core.git',
    revision => 'master',
    user     => 'www-data',
    require  => [
      Class['git'],
      File['/var/www']
    ],
    notify   => File['/var/www/owncloud/data'],
  }

  file { '/var/www/owncloud/data':
    owner    => 'www-data',
    mode     => 770,
    group    => 'www-data',
    ensure   => directory,
  }

  vcsrepo { '/var/www/3rdparty':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/owncloud/3rdparty.git',
    revision => 'master',
    user     => 'www-data',
    require  => [
      Class['git'],
      File['/var/www']
    ],
  }

  vcsrepo { '/var/www/apps':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/owncloud/apps.git',
    revision => 'master',
    user     => 'www-data',
    require  => [
      Class['git'],
      File['/var/www']
    ],
  }
}
