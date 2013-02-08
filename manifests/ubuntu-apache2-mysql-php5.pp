#############################
# Vagrant LAMP Stack Config #
#############################
# OS          : Linux       #
# Database    : MySQL 5     #
# Web Server  : Apache 2    #
# PHP version : 5.3         #
#############################

include apache
include php
include mysql

# Apache setup
class {'apache::mod::php': }

apache::vhost { $fqdn :
	priority => '20',
	port => '80',
	docroot => $docroot,
	configure_firewall => false,
}

a2mod { 'rewrite': ensure => present; }

# PHP Extensions
php::module { ['xdebug', 'mysql', 'curl', 'gd'] : 
    notify => [ Service['httpd'], ],
}

# MySQL Server
class { 'mysql::server':
  config_hash => { 'root_password' => 'root' }
}

mysql::db { 'lamp':
    user     => 'lamp',
    password => 'lamp',
    host     => 'localhost',
    grant    => ['all'],
    charset  => 'utf8',
}

# Other Packages
$extras = ['vim', 'curl', 'phpunit']
package { $extras : ensure => 'installed' }

file { $docroot:
    ensure  => 'directory',
}