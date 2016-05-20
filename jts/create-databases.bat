
sqlcmd -v db=jts -v user=jtsUser -v password=P@ssw0rd66 -v collation=SQL_Latin1_General_CP437_CS_AS -i create-database.sql
sqlcmd -v db=ccm -v user=ccmUser -v password=P@ssw0rd66 -v collation=SQL_Latin1_General_CP437_CS_AS -i create-database.sql
sqlcmd -v db=qm  -v user=qmUser  -v password=P@ssw0rd66 -v collation=SQL_Latin1_General_CP437_CS_AS -i create-database.sql
sqlcmd -v db=gc  -v user=gcUser  -v password=P@ssw0rd66 -v collation=SQL_Latin1_General_CP437_CS_AS -i create-database.sql
sqlcmd -v db=dw  -v user=dwUser  -v password=P@ssw0rd66 -v collation=SQL_Latin1_General_CP1_CS_AS -i create-database.sql

