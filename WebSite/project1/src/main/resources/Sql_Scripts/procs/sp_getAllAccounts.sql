USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_getAllAccounts]    Script Date: 08/12/2020 9:27:55 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sebastián Alpizar>
-- Create date: <14/11/2020>
-- Description:	<SP que obtiene las cuentas de un usuario>
-- =============================================
ALTER PROCEDURE [dbo].[sp_getAllAccounts]

AS
BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    --Selecciona las cuentas relacionadas con un nombre de usuario
    SELECT *
    FROM [dbo].[CuentaAhorros]

END
