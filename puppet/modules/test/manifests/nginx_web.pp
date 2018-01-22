class test::nginx_web {
	$nginx_port  = hiera("nginxport", '8080')
	package {"nginx":
		ensure => present,
		require => File["/etc/yum.repos.d/nginx.repo"]
	}
	file {"/etc/yum.repos.d/nginx.repo":
		ensure => present,
		source => "puppet:///modules/test/nginx.repo",
		owner  => root, 
		group  => root,
		mode   => 640
	}
	file {"/etc/nginx/conf.d/default.conf":
		ensure  => present,
                content => template("test/default.conf.erb"),
                owner   => root,
                group   => root,
                mode    => 640,
		require => Package["nginx"],
		notify  => Service["nginx"]
	}
	service {"nginx":
                ensure    => running, 
		enable    => true,
                subscribe => File["/etc/nginx/conf.d/default.conf"]
	}
}

