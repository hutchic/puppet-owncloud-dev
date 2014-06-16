class owncloud-dev () {
  include 'make'
  include 'mysql::server'
  include 'git'
  include 'composer'

  class { 'apache':
    mpm_module => prefork
  }
  include apache::mod::php

  anchor { 'owncloud-dev::begin': } ->
  class { '::owncloud-dev::install': } ->
  anchor { 'owncloud-dev::end': }
}
