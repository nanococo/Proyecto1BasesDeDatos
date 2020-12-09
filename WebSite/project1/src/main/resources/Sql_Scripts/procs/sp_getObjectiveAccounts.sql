USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_getObjectiveAccounts]    Script Date: 08/12/2020 9:29:33 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Alpizar, Sebastian>
-- Create date: <Created: 07/12/2020>
-- Description:	<Obtiene todas las cuentas objetivo basadas en la cuenta principal>
-- =============================================
ALTER PROCEDURE [dbo].[sp_getObjectiveAccounts]

@inAccountId int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT * FROM [dbo].[CuentaObjetivo]
    WHERE [CuentaAhorrosId] = @inAccountId AND [Activo] = 1

END
