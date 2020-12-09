USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_eliminarCuentaObjetivo]    Script Date: 08/12/2020 9:27:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sebas Alpizar>
-- Create date: <08/12/2020>
-- Description:	<Elimina una cuenta objetivo>
-- =============================================
ALTER PROCEDURE [dbo].[sp_eliminarCuentaObjetivo]

@inId INT

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
            SET [Activo] = 0

            WHERE [Id] = @inId
            SET @Return_Status = 1

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

    COMMIT

    RETURN @Return_Status

END
