# httpd server

class httpd {

    $httpd_version = "2.2.21-1.x86_64.rpm"
    $mod_ssl_version = "2.2.21-1.x86_64.rpm"
    $modulename = "httpd"

    file { "httpd-rpm":
        path => "/tmp/httpd-${httpd_version}",
        source => "puppet:///modules/$modulename/httpd-${httpd_version}"
    }

    file { "mod_ssl-rpm":
        path => "/tmp/mod_ssl-${mod_ssl_version}",
        source => "puppet:///modules/$modulename/mod_ssl-${mod_ssl_version}"
    }

    exec { "yum-localinstall-httpd":
        command => "/usr/bin/yum localinstall --skip-broken -y /tmp/httpd-${httpd_version}",
        unless  => "/bin/rpm -q httpd-${httpd_version}",
        require => file["httpd-rpm"],
    }

    exec { "yum-localinstall-mod_ssl":
        command => "/usr/bin/yum localinstall --skip-broken -y /tmp/mod_ssl-${mod_ssl_version}",
        unless  => "/bin/rpm -q mod_ssl-${mod_ssl_version}",
        require => file["mod_ssl-rpm"],
    }

    file { "/etc/httpd/conf.d":
        ensure => directory,
        require => Exec["yum-localinstall-httpd", "yum-localinstall-mod_ssl"],
    }

#    file { "/etc/httpd/conf/httpd.conf":
#        ensure => file,
#        content => template("httpd/httpd.conf.erb"),
#        require => File["/etc/httpd/conf.d"],
#    }
    exec { "restart-httpd":
        command => "/sbin/service httpd restart",
        unless  => "/bin/rpm -q httpd-${httpd_version}",
#        require => file["/etc/httpd/conf/httpd.conf"],
   }
}
