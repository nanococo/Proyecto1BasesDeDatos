USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_insertarBeneficiario]    Script Date: 14/11/2020 7:27:25 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Brayan Marín>
-- Create date: <10/11/2020>
-- Description:	<SP que inserta un beneficiario. Se asume que la persona ya está en la BD>
-- =============================================
ALTER PROCEDURE [dbo].[sp_insertarBeneficiario]

    @ValorDocIdentidadBeneficiario VARCHAR(20),
    @CuentaId INT,
    @Porcentaje INT,
    @Parentesco VARCHAR(20)

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @PersonaId INT
    DECLARE @ParentescoId INT
    DECLARE @CantBeneficiarios INT
    DECLARE @PorcentajeTotalCuenta INT

	--Variable para manejo de errores (1 si el sp se ejecutó correctamente, 0 si el sp falló)
	DECLARE @Return_Status INT
	SET @Return_Status = 0

    --Se obtienen los Id de la persona y la cuenta
    SET @PersonaId = (SELECT Id FROM [dbo].[Persona] AS P WHERE @ValorDocIdentidadBeneficiario = P.ValorDocumentoIdentidadDelCliente)
    SET @ParentescoId = (SELECT Id FROM [dbo].[Parentescos] AS PA WHERE @Parentesco = PA.Nombre)

    --Se obtiene la cantidad de beneficiarios asociados a la cuenta
    SET @CantBeneficiarios = (SELECT COUNT(*) FROM [dbo].[Beneficiarios] AS B WHERE B.CuentaAsociadaId = @CuentaId AND B.EstaActivo = 1)

    --Se obtiene el porcentaje actual de la cuenta repartido entre los beneficiarios
    SET @PorcentajeTotalCuenta = (SELECT SUM(B.Porcentaje) FROM [dbo].[Beneficiarios] AS B WHERE B.CuentaAsociadaId = @CuentaId AND B.EstaActivo = 1)

    --Se valida que PorcentajeTotalCuenta no sea nulo
    IF (@PorcentajeTotalCuenta IS NULL)
    BEGIN
        SET @PorcentajeTotalCuenta = 0
    END

    --Si la cantidad de beneficiarios es menor a 3, si el porcentaje de la cuenta es menor a 100 y si la suma del porcentaje total más el porcentaje nuevo es menor o igual a 100, inserta
    IF (@CantBeneficiarios < 3 AND @PorcentajeTotalCuenta < 100 AND @Porcentaje + @PorcentajeTotalCuenta <= 100)
    BEGIN

        --No deja insertar un beneficiario igual a la misma cuenta. También valida si el beneficiario está activo o no. En caso de que exista pero este no está activo, lo inserta
        IF NOT EXISTS(SELECT * FROM [dbo].[Beneficiarios] AS B WHERE @PersonaId = B.PersonaId AND @CuentaId = B.CuentaAsociadaId AND B.EstaActivo = 1)
            BEGIN

				--Try Catch  para manejar errores y almancenarlos en DB_Errores en caso de que ocurran
				BEGIN TRY

					--Insercion en tabla Beneficiarios
					INSERT INTO [dbo].[Beneficiarios] ([PersonaId], [CuentaAsociadaId], [Porcentaje], [ParentescoId])
					VALUES (@PersonaId, @CuentaId, @Porcentaje, @ParentescoId)
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
            END

    END 
		
	RETURN @Return_Status

END
