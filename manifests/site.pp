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

  #include ::borrower_frontend
  include ::case_api
  #include ::deed_api


  service { 'firewalld':
    ensure => 'stopped',
  }
}
