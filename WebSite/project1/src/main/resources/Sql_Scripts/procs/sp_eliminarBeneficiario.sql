USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_eliminarBeneficiario]    Script Date: 14/11/2020 7:25:16 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Brayan Marín>
-- Create date: <10/11/2020>
-- Description:	<SP que elimina al beneficiario>
-- =============================================
ALTER PROCEDURE [dbo].[sp_eliminarBeneficiario]

    @IdBeneficiario INT,
    @IdCuentaAsociada INT

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	--Variable para manejo de errores (1 si el sp se ejecutó correctamente, 0 si el sp falló)
	DECLARE @Return_Status INT
	SET @Return_Status = 0

    --Cambiar estado y asignar fecha de desactivacion
    DECLARE @Existingdate DATE
    SET @Existingdate = GETDATE()

	--Try Catch  para manejar errores y almancenarlos en DB_Errores en caso de que ocurran
	BEGIN TRY 
		
		--Se realiza el eliminado lógico del Beneficiario y se asigna la fecha de desactivación
		UPDATE [dbo].[Beneficiarios]
		SET
			EstaActivo = 0,
			FechaDesactivacion = CONVERT(VARCHAR, @Existingdate, 21)

		WHERE Id = @IdBeneficiario AND CuentaAsociadaId = @IdCuentaAsociada

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

	RETURN @Return_Status

END
