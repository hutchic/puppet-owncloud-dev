class owncloud-dev () {
  include 'make'
  include 'mysql::server'
  include 'git'
  include 'composer'

  anchor { 'owncloud-dev::begin': } ->
  class { '::owncloud-dev::install': } ->
  anchor { 'owncloud-dev::end': }
}
