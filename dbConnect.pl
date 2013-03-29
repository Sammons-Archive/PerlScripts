#!/usr/bin/perl

use DBI; 
print "content-type:text/html\n\n";
$db = DBI->connect('dbi:mysql:db:ip:port','id','pass') or die("Couldn't connect");

$db ->do('CREATE TABLE `test`.`actor` (

  `actor_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,

  `first_name` varchar(45) NOT NULL,

  `last_name` varchar(45) NOT NULL,

  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`actor_id`),

  KEY `idx_actor_last_name` (`last_name`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8$$');