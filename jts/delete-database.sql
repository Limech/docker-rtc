USE $(db)

ALTER AUTHORIZATION ON DATABASE::$(db) TO sa

IF EXISTS 
   (SELECT name FROM master.sys.server_principals
    WHERE name = '$(user)')
BEGIN
    DROP LOGIN $(user)
END
GO

USE master;
ALTER DATABASE $(db)
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE [$(db)]
GO


