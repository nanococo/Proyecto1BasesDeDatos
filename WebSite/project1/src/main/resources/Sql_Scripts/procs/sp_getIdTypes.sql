USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_getIdTypes]    Script Date: 08/12/2020 9:28:47 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sebastián Alpizar>
-- Create date: <14/11/2020>
-- Description:	<SP que obtiene los parentescos ordenados por Id>
-- =============================================
ALTER PROCEDURE [dbo].[sp_getIdTypes]

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    --Selecciona lo parentescos ordenados por Id
    SELECT *
    FROM [dbo].[TipoDocIdentidad]
    ORDER BY [Id]

END
