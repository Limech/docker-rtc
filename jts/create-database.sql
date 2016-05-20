USE master;
GO

IF DB_ID (N'$(db)') IS NOT NULL
DROP DATABASE $(db);
GO

CREATE DATABASE $(db)
COLLATE SQL_Latin1_General_CP437_CS_AS
GO

USE $(db);

IF NOT EXISTS 
   (SELECT name FROM master.sys.server_principals
    WHERE name = '$(user)')
BEGIN
   CREATE LOGIN $(user)
   WITH PASSWORD='$(password)';
END
GO


ALTER DATABASE $(db)
SET READ_COMMITTED_SNAPSHOT ON
GO

ALTER AUTHORIZATION ON DATABASE::$(db) TO $(user)
