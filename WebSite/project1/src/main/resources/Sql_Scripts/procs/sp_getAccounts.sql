USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_getAccounts]    Script Date: 14/11/2020 7:25:52 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sebastián Alpizar>
-- Create date: <14/11/2020>
-- Description:	<SP que obtiene las cuentas de un usuario>
-- =============================================
ALTER PROCEDURE [dbo].[sp_getAccounts]  

	@username VARCHAR(30)

AS
BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	--Selecciona las cuentas relacionadas con un nombre de usuario
	SELECT * 
	FROM [dbo].[CuentaAhorros]
	WHERE [Id] IN (SELECT CuentaId FROM UsuariosVer WHERE UserId = (SELECT Usuarios.Id FROM Usuarios WHERE Usuarios.Username = @username))
	
END