USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_getStatementsByAccountId]    Script Date: 14/11/2020 7:27:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sebastián Alpizar>
-- Create date: <14/11/2020>
-- Description:	<SP que obtiene los estados de cuenta con el Id de la cuenta>
-- =============================================
ALTER PROCEDURE [dbo].[sp_getStatementsByAccountId]

	@accountId VARCHAR(20)

AS
BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	--Select que obtiene los estados de cuenta con el Id de la cuenta
	SELECT *
	FROM   [dbo].[EstadoCuenta]
	WHERE  [CuentaAhorrosId] = @accountId

END