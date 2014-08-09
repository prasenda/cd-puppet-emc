# EXTRACT 

class rest-extract {

    $api_war_name="extract.war"
    $api_directory="extract"
    $api_location="/usr/share/tomcat6/webapps"
    $dtac_api_conf="/etc/dtac/rest-extract/conf"
    $restx_xml_conf="restx-conf.xml"
    $log4j_xml_conf="log4j.xml"
    $api_log="/var/log/dtac/rest-extract"

    $jmx_jar_name="catalina-jmx-remote.jar"


    file { "$api_war_name":
        path => "$api_location/$api_war_name",
        source => "puppet:///modules/rest-extract/$api_war_name",
        ensure => present,
        owner => tomcat,
        group => tomcat,
    }

#restart command
   exec { "restart_tomcat":
       command => "/etc/init.d/tomcat6 restart",
     require => File["$api_location/$api_war_name"],
    }
}

