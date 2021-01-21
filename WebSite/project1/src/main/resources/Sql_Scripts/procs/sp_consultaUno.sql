USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_consultaUno]    Script Date: 21/01/2021 12:48:02 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sebastian Alpizar
-- Create date: 10/01/21
-- Description:	Este documento procesa la insercion de datos
-- =============================================
ALTER PROCEDURE [dbo].[sp_consultaUno]
    -- Add the parameters for the stored procedure here

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;


    --Declaracion de variables


    DECLARE @temp TABLE (
                            Id INT IDENTITY (1,1),
                            IdCuentaObjetivo INT,
                            Descripcion VARCHAR(50),
                            CantidadDepositosHechos INT,
                            CantidadEsperadaDepositos INT,
                            SaldoReal INT,
                            SaldoTotalEsperado INT
                        )


    DECLARE @cuentaObjetivoId INT
    DECLARE @cuentaAhorroId   INT

    DECLARE cursor_CO CURSOR
        FOR SELECT Id, CuentaAhorrosId FROM [dbo].[CuentaObjetivo]

    OPEN cursor_CO
    FETCH NEXT FROM cursor_CO INTO
        @cuentaObjetivoId,
        @cuentaAhorroId;

    WHILE @@FETCH_STATUS = 0
        BEGIN

            DECLARE @SaldoFinalAntesDeRendicion MONEY,
                @fechaInicio DATE,
                @fechaFin DATE,
                @diaAhorro INT,
                @montoAhorro MONEY,
                @descripcion VARCHAR(50),
                @saldoReal MONEY


            SELECT	@SaldoFinalAntesDeRendicion = [SaldoFinalAntesDeRendicion],
                      @FechaInicio = [fechaInicio],
                      @FechaFin = [FechaFin],
                      @DiaAhorro = [DiaAhorro],
                      @Descripcion = [Descripcion],
                      @saldoReal = [SaldoCO],
                      @montoAhorro = [MontoAhorro]
            FROM [dbo].[CuentaObjetivo]
            WHERE Id = @cuentaObjetivoId



            DECLARE @numeroDeDiasEntreFechas INT = ([dbo].timesADayIsFoundBetweenDates(@fechaInicio, @fechaFin, @diaAhorro))
            DECLARE @saldoEsperado MONEY = (@numeroDeDiasEntreFechas * @montoAhorro)



            IF @SaldoFinalAntesDeRendicion != @saldoEsperado
                BEGIN

                    DECLARE @cantidadDepositosHechos INT = (SELECT COUNT(*)
                                                            FROM [dbo].[MovimientosCO]
                                                            WHERE CuentaObjetivoId = @cuentaObjetivoId
                    )

                    IF @cantidadDepositosHechos IS NOT NULL
                        BEGIN
                            INSERT INTO @temp (IdCuentaObjetivo, Descripcion, CantidadDepositosHechos, CantidadEsperadaDepositos, SaldoReal, SaldoTotalEsperado)
                            VALUES (@cuentaObjetivoId, @descripcion, @cantidadDepositosHechos, @numeroDeDiasEntreFechas, @saldoReal, @saldoEsperado)
                        END


                END

            FETCH NEXT FROM cursor_CO INTO
                @cuentaObjetivoId,
                @cuentaAhorroId;

        END

    CLOSE cursor_CO
    DEALLOCATE cursor_CO

    SELECT * FROM @temp


END
