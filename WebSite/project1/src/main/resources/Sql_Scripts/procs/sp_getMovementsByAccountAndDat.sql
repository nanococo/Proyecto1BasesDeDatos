USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_getMovementsByAccountAndDat]    Script Date: 08/12/2020 9:02:53 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_getMovementsByAccountAndDat]

    @accountId INT,
    @startDate DATE,
    @endDate DATE

AS
    IF @endDate IS NULL
        SELECT * FROM Movimientos AS M WHERE M.CuentaAhorrosId=@accountId AND M.Fecha >= @startDate
    ELSE
        SELECT * FROM Movimientos AS M WHERE M.CuentaAhorrosId=@accountId AND M.Fecha BETWEEN @startDate AND @endDate