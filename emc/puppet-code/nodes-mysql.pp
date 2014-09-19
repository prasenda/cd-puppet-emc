# edit this file to fit your network and service

node deployment-param  {
    $tomcat_install_path = "/opt/"
    $modulename = "mysql-dc"
    $mysql_version = "5.1.50-1"
    $mysql_server_port = "3306"
    $httpd_version = "2.2.21-1.x86_64.rpm"
    $mod_ssl_version = "2.2.21-1.x86_64.rpm"

}

node 'ip-10-1-134-144.ec2.internal' inherits  deployment-param {
    include mysql-dc::mysql-server
    #include tomcat6
    #include rest-extract 
    #include httpd
}

