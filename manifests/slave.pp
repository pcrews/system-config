import "openstack_ci_admins_users"
import "static_users"

node default {
  include openstack_ci_admins_users
  include static_users

    package { "python-software-properties":
        ensure => latest
          }

    package { "openjdk-6-jre":
        ensure => latest
          }
    
    package { "puppet":
        ensure => latest
          }
    
    package { "bzr":
        ensure => latest
          }
    
    package { "git":
        ensure => latest
          }
    
    package { "python-setuptools":
        ensure => latest
          }
    
    package { "python-sphinx":
        ensure => latest
          }
    
    package { "graphviz":
        ensure => latest
          }
    
    package { "pep8":
        ensure => latest
          }
    
    package { "pylint":
        ensure => latest
          }
    
    package { "byobu":
        ensure => latest
          }
}
