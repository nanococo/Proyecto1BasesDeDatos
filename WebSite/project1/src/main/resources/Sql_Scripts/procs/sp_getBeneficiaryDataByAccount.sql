USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_getBeneficiaryDataByAccount]    Script Date: 14/11/2020 7:26:19 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sebastián Alpizar>
-- Create date: <14/11/2020>
-- Description:	<SP que obtiene los datos del beneficiario a partir del Id de la cuenta>
-- =============================================
ALTER PROCEDURE [dbo].[sp_getBeneficiaryDataByAccount] 

	@accountId VARCHAR (30)

AS
BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	SELECT * 
	FROM [dbo].[Persona], [dbo].[Beneficiarios]
	WHERE [dbo].[Persona].[Id] IN (SELECT [PersonaId]
							FROM [dbo].[Beneficiarios]
							WHERE [dbo].[Beneficiarios].[CuentaAsociadaId] = @accountId)
							AND [dbo].[Beneficiarios].[CuentaAsociadaId] = @accountId
							AND [dbo].[Persona].[Id] = [dbo].[Beneficiarios].[PersonaId]
							AND [Beneficiarios].[EstaActivo] = '1'
END