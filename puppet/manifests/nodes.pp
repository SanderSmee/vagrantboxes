node 'postgresql.vagrant.dev' {
	class { 'postgresql::globals':
		manage_package_repo => true,
		encoding => 'UTF-8',
	  	version  => '9.2',
	}

	class { 'postgresql::server':
		ip_mask_allow_all_users => '0.0.0.0/0',
		listen_addresses        => '*',
	}

	postgresql::server::role { 'brp':
		password_hash => postgresql_password('brp', 'brp'),
		login         => true,
	}

	postgresql::server::database { 'brp':
		owner => 'brp',
		require => Postgresql::Server::Role['brp'],
	}
	postgresql::server::database { 'brpjunit':
		owner => 'brp',
		require => Postgresql::Server::Role['brp'],
	}
	postgresql::server::database { 'art-brp':
		owner => 'brp',
		require => Postgresql::Server::Role['brp'],
	}
}

node 'tomcat.vagrant.dev' {
	class { 'java':
		distribution => 'jdk',
		version      => 'latest',
	}

	class { 'tomcat':
		package => 'tomcat7',
	}
}

node 'neo4j.vagrant.dev' {
	class { 'neo4j':
	}
}

node 'mysql.vagrant.dev' {
	class { '::mysql::server':
		root_password           => 'root',
		remove_default_accounts => false,
		restart                 => true,
		override_options => { 'mysqld' => { 'max_connections' => '1024' } }

		databases => {
		  'iddd_common_test' => {
		    ensure  => 'present',
		    charset => 'utf8',
		  },
		  'iddd_iam' => {
		    ensure  => 'present',
		    charset => 'utf8',
		  },
		  'iddd_collaboration' => {
		    ensure  => 'present',
		    charset => 'utf8',
		  },
		},

		grants => {
		  'root@localhost/*.*' => {
		    ensure     => 'present',
		    options    => ['GRANT'],
		    privileges => ['ALL'],
		    table      => '*.*',
		    user       => 'root@localhost',
		  },
		}
	}
}
