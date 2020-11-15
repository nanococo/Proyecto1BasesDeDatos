USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_getKinships]    Script Date: 14/11/2020 7:26:41 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sebastián Alpizar>
-- Create date: <14/11/2020>
-- Description:	<SP que obtiene los parentescos ordenados por Id>
-- =============================================
ALTER PROCEDURE [dbo].[sp_getKinships]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Selecciona lo parentescos ordenados por Id
	SELECT * 
	FROM [dbo].[Parentescos] 
	ORDER BY [Id]

END