USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_testLogin]    Script Date: 14/11/2020 7:28:08 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sebastián Alpizar>
-- Create date: <14/11/2020>
-- Description:	<SP que ace un test del login>
-- =============================================
ALTER PROCEDURE [dbo].[sp_testLogin]

	@username VARCHAR(30), 
	@password VARCHAR(30)

AS
BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	--Verifica la existencia de un username asociado con la contraseña digitada por el usuario
	SELECT * 
	FROM [dbo].[Usuarios] AS U
	WHERE [U].[Username] = @username and [U].[Password] = @password
	
END