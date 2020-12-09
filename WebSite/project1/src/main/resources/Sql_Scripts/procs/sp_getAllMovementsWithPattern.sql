USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_getAllMovementsWithPattern]    Script Date: 08/12/2020 9:20:50 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Brayan Marín Quirós>
-- Create date: <7/12/2020>
-- Description:	<Sp que obtiene todos los movimientos que tengan cierto patrón de una cuenta>
-- =============================================
ALTER PROCEDURE [dbo].[sp_getAllMovementsWithPattern]

    @inAccountId INT,
    @inStartDate DATE,
    @inEndDate DATE,
    @INText VARCHAR(256)

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    IF @inEndDate IS NULL
        SELECT * FROM Movimientos AS M WHERE M.CuentaAhorrosId=@inAccountId AND M.Fecha >= @inStartDate AND  M.[Descripcion] like '%' + @INText + '%'
    ELSE
        SELECT * FROM Movimientos AS M WHERE M.CuentaAhorrosId=@inAccountId AND M.Fecha BETWEEN @inStartDate AND @inEndDate AND  M.[Descripcion] like '%' + @INText + '%'

END
