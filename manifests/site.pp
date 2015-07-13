# Default executable path
Exec { path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' }

# Default file permissions to root:root
File { owner => 'root', group => 'root', }

# Explicitly set 'allow virtual packages to false' in order to surpres error
# message on CentOS.
if versioncmp($::puppetversion,'3.6.1') >= 0 {

  $allow_virtual_packages = hiera('allow_virtual_packages',false)

  Package {
    allow_virtual => $allow_virtual_packages,
  }
}

node default {
  require ::standard_env
  require ::standard_env::tools::cucumber

  $require_database = hiera('require_database', false)
  if $require_database {
    require charges_postgres
  }

  service { 'firewalld':
    ensure => 'stopped',
  }
}

class charges_postgres (
  $owner = hiera('postgres::database_owner', "vagrant"),
  $password = hiera('postgres::database_password', "password")
) {
  require ::postgresql::server
  require ::postgresql::lib::devel

  postgresql::server::db { 'charges':
    user     => $owner,
    password => postgresql_password($owner, $password),
  }
}
