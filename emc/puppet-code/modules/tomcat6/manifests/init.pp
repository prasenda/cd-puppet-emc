# Tomcat module

class tomcat6 {

    $tomcat = "tomcat6"

    package { "$tomcat": 
        ensure => latest,
    }

    file { "tomcat_conf":
	    path => "/usr/share/$tomcat/conf/$tomcat.conf",
    	content => template("$tomcat/conf/$tomcat.conf.erb"),
        require => Package["$tomcat"],
    }

}
