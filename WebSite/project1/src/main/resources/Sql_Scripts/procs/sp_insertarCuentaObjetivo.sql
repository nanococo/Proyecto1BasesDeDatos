USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_insertarCuentaObjetivo]    Script Date: 07/12/2020  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Sebastian Alpizar>
-- Create date: <10/11/2020>
-- Description:	<SP que inserta unna cuenta objetivo. Se asume que la cuenta ya existe>
-- =============================================
ALTER PROCEDURE [dbo].[sp_insertarCuentaObjetivo]

    @inCuentaAhorrosId INT,
    @inFechaInicio DATE,
    @inFechaFin DATE,
    @inDiaAhorro INT,
    @inSaldo MONEY,
    @inDescrpcion VARCHAR(50)

AS
BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    --Variable para manejo de errores (1 si el sp se ejecutó correctamente, 0 si el sp falló)
    DECLARE @OutReturn_Status INT
    SET @OutReturn_Status = 0


    BEGIN TRY

        INSERT INTO [dbo].[CuentaObjetivo] ([CuentaAhorrosId], [FechaInicio], [FechaFin], [DiaAhorro], [SaldoCO], [Descripcion], [Activo])
        VALUES (@inCuentaAhorrosId, @inFechaInicio, @inFechaFin, @inDiaAhorro, @inSaldo, @inDescrpcion, 1)
        SET @OutReturn_Status = 1
        RETURN @OutReturn_Status

    END TRY

    BEGIN CATCH

        --Insercion del error en tabla DB_Errores
        INSERT INTO [dbo].[DB_Errores]
        VALUES  (SUSER_SNAME(),
                 ERROR_NUMBER(),
                 ERROR_STATE(),
                 ERROR_SEVERITY(),
                 ERROR_LINE(),
                 ERROR_PROCEDURE(),
                 ERROR_MESSAGE(),
                 GETDATE());

        RETURN @OutReturn_Status

    END CATCH



END