USE [Banco]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_editarCuentaObjetivo]

    @inId INT,
    @inAmount MONEY,
    @inDescription VARCHAR(50),
    @inStartDate DATE,
    @inEndDate DATE,
    @inProccessDate INT

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here

    --Variable para manejo de errores (1 si el sp se ejecutó correctamente, 0 si el sp falló)
    DECLARE @Return_Status INT
    SET @Return_Status = 0

    BEGIN TRANSACTION updateProccess

        BEGIN TRY

            UPDATE [dbo].[CuentaObjetivo]
            SET [SaldoCO] = @inAmount,
                [Descripcion] = @inDescription,
                [FechaInicio] = @inStartDate,
                [FechaFin] = @inEndDate,
                [DiaAhorro] = @inProccessDate

            WHERE Id = @inId
            SET @Return_Status = 1
            RETURN @Return_Status

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

        END CATCH

        RETURN @Return_Status

    COMMIT

END
GO
