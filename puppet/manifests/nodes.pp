node 'postgresql.vagrant.dev' {
	class { 'postgresql::globals':
		manage_package_repo => true,
		encoding => 'UTF-8',
	  	version  => '9.3',
	}

	class { 'postgresql::server':
		ip_mask_allow_all_users => '0.0.0.0/0',
		listen_addresses        => '*',
	}

	postgresql::server::db { 'mydatabasename':
	  user     => 'mydatabaseuser',
	  password => postgresql_password('mydatabaseuser', 'mypassword'),
	}
}

node 'tomcat.vagrant.dev' {

}
