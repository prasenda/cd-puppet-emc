
class mysql-dc::mysql-server {

    $modulename = "mysql-dc"

    # variable child classes can use our EXEC
    #
    $install_mysql_server = "install_mysql_server" 

    # $mysql_version = "5.1.50-1"
    $mysql_server_rpm = "MySQL-server-${mysql_version}.glibc23.x86_64.rpm"
    $password = "nokia123"

    file { "/tmp/$mysql_server_rpm":
        source => "puppet:///modules/$modulename/$mysql_server_rpm"
    }

    exec { "dc-mysql-restart-required":
        command     => "/bin/touch /var/tmp/.dc.mysql.restart.lock",
        refreshonly => true;
    }

    # $mysql_server_port should be defined in nodes.pp
    #
    define install_mysql_server($mysql_version)
    {
        $mysql_server_rpm = "MySQL-server-${mysql_version}.glibc23.x86_64.rpm"

        #
        file { "/etc/my.cnf.dc" :
            content => template("mysql-dc/my.cnf.erb"),
            path => "/etc/my.cnf.dc",
            owner   => root,
            group   => root,
            mode    => 644,
            notify => Exec["dc-mysql-restart-required"];
        }

        exec { "my-cnf-dc":
               command => "/bin/mv  /etc/my.cnf.dc  /etc/my.cnf",
               require => File["/etc/my.cnf.dc"]
        }


        exec { "MySQL-server":
            command => "/bin/rpm -i /tmp/$mysql_server_rpm",
            unless => '/bin/rpm -qa | grep "MySQL-server-${mysql_version}"',
            notify => Exec["dc-mysql-restart-required"],
            require => File["/tmp/$mysql_server_rpm", "/etc/my.cnf.dc"];
        }
    }

    install_mysql_server { "$install_mysql_server":
        mysql_version => $mysql_version
    }

    exec { "mysql-dc-init.d":
        command => "/bin/mv /usr/sbin/mysqld /etc/init.d/mysql-dc",
        subscribe => Exec["MySQL-server"] 
    }

#    exec { "set-mysql-pw":
#        subscribe => [ Exec["MySQL-server"] ],
#        refreshonly => true,
#        unless => "mysqladmin -uroot -p$password status",
#        path => "/bin:/usr/bin",
#        command => "mysqladmin -uroot password $password",
#    }

    service { "mysql-dc" :
        name => "mysql-dc",
        ensure => running,
        hasstatus => true,
        subscribe => [ Exec["dc-mysql-restart-required", "MySQL-server"] ],
    }

}
