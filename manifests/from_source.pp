class owncloud-dev::from_source () {
  include 'apache::mod::php'
  include 'make'
  include 'mysql::server'
  include 'git'
  include 'composer'

  class { 'apache':
    mpm_module => prefork
  }

  apache::vhost { 'owncloud.dev':
    port               => '80',
    docroot            => '/var/www/owncloud/',
    directories        => [
      { path           => '/var/www/owncloud/',
        allow_override => ['All'],
      },
    ]
  }

  php::module { [ 'gd', 'mysql' ]:
    require  => Class['php'],
  }

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
    require  => Vcsrepo['/var/www/owncloud'],
  }

  file { '/var/www/owncloud/apps':
    owner    => 'www-data',
    mode     => 770,
    group    => 'www-data',
    ensure   => directory,
    require  => Vcsrepo['/var/www/owncloud'],
  }

  owncloud_dev::app{ 'news':
    dir      => '/var/www/owncloud/apps/news',
    source   => 'https://github.com/owncloud/news.git',
  }

  owncloud_dev::app{ 'gallery':
    dir      => '/var/www/owncloud/apps/gallery',
    source   => 'https://github.com/owncloud/gallery.git',
  }

  owncloud_dev::app{ 'music':
    dir      => '/var/www/owncloud/apps/music',
    source   => 'https://github.com/owncloud/music.git',
  }

  owncloud_dev::app{ 'notes':
    dir      => '/var/www/owncloud/apps/notes',
    source   => 'https://github.com/owncloud/notes.git',
  }

  owncloud_dev::app{ 'calendar':
    dir      => '/var/www/owncloud/apps/calendar',
    source   => 'https://github.com/owncloud/calendar.git',
  }

  owncloud_dev::app{ 'contacts':
    dir      => '/var/www/owncloud/apps/contacts',
    source   => 'https://github.com/owncloud/contacts.git',
  }

  owncloud_dev::app{ 'documents':
    dir      => '/var/www/owncloud/apps/documents',
    source   => 'https://github.com/owncloud/documents.git',
  }

  owncloud_dev::app{ 'chat':
    dir      => '/var/www/owncloud/apps/chat',
    source   => 'https://github.com/owncloud/chat.git',
  }

  owncloud_dev::app{ 'bookmarks':
    dir      => '/var/www/owncloud/apps/bookmarks',
    source   => 'https://github.com/owncloud/bookmarks.git',
  }
}

define owncloud_dev::app(
   $dir,
   $source,
) {
  vcsrepo { $dir:
    ensure   => present,
    provider => git,
    source   => $source,
    revision => 'master',
    user     => 'www-data',
    require   => [
      Class['git'],
      File['/var/www/owncloud/apps']
    ]
  }
}