
class mysql-dc::mysql-client {

    $modulename = "mysql-dc"

    $mysql_version = "5.1.50-1"

    $mysql_shared_rpm = "MySQL-shared-${mysql_version}.glibc23.x86_64.rpm"
    $mysql_client_rpm = "MySQL-client-${mysql_version}.glibc23.x86_64.rpm"

    file { "/tmp/$mysql_client_rpm":
        source => "puppet:///$modulename/$mysql_client_rpm"
    }

    file { "/tmp/$mysql_shared_rpm":
        source => "puppet:///$modulename/$mysql_shared_rpm"
    }

    exec { "MySQL-client":
        command => "rpm -i /tmp/$mysql_client_rpm",
        unless => 'rpm -qa | grep "MySQL-client-${mysql_version}"',
        require => File["/tmp/$mysql_client_rpm"];
    }

    exec { "MySQL-shared":
        command => "rpm -i /tmp/$mysql_shared_rpm",
        unless => 'rpm -qa | grep "MySQL-shared-${mysql_version}"',
        require => File["/tmp/$mysql_shared_rpm"];
    }


#    package { "MySQL-shared":
#    package { "MySQL-shared-5.1.50-1":
#    package { "MySQL-shared-5.1.50":
#    package { "MySQL-shared-compat":
#    package { "MySQL-shared-5.1.50-1.glibc23":
#    package { "MySQL-shared-5.1.50-1.glibc23.x86_64":
#        ensure => installed,
#        ensure => "5.1.50",
#        source => "/tmp";
#        source => "/tmp/$mysql_shared_rpm",
#        source => "puppet:///datacloud/$mysql_shared_rpm",
#        provider => "yum";
#    }

#    package { "MySQL-client":
#    package { "MySQL-client-community":
#        ensure => "5.1.50",
#        source => "/tmp/$mysql_client_rpm";
#        source => "puppet:///datacloud/$mysql_client_rpm";
#    }

#    package { "MySQL-shared": ensure => "5.1.50", require => File["/etc/yum.conf"] }
#    package { "MySQL-client.x86_64": ensure => "5.1.50", require => File["/etc/yum.conf"] }

}
