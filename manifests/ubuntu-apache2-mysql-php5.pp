#############################
# Vagrant LAMP Stack Config #
#############################
# OS          : Linux       #
# Database    : MySQL 5     #
# Web Server  : Apache 2    #
# PHP version : 5.3         #
#############################

# install apache and mysql
class{ 'apache': }
class{ 'php': }

# create a virtual host using tha data provided in the vagrantfile
apache::vhost { $fqdn:
  docroot  => $docroot,
  port => '80',
  priority => '20',
}

# ensure mod_php and mod_rewrite are installed
apache::module { ['php5', 'rewrite']: }

# ensure other useful php modules are installed
php::module { ['xdebug', 'mysql', 'curl', 'gd', 'mcrypt']: }

# install mysql
class { 'mysql':
  root_password => 'root',
}

# create the database
mysql::grant { $db_name:
  mysql_privileges => 'ALL',
  mysql_password => $db_pass,
  mysql_db => $db_name,
  mysql_user => $db_user,
  mysql_host => $db_host,
  mysql_grant_filepath => '/root/mysql',
}

# set pear auto_discover to 1
php::pear::config{ 'auto_discover':
  value => '1',
}

#install phpunit
php::pear::module{ 'pear.phpunit.de/PHPUnit': 
  use_package => 'no',
}

# ensure the docroot is a directory, that's it.
file { $docroot:
    ensure  => 'directory',
}