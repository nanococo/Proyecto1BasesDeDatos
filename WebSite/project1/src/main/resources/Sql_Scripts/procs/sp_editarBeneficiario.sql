USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_editarBeneficiario]    Script Date: 08/12/2020 9:25:46 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Brayan Marín>
-- Create date: <10/11/2020>
-- Description:	<SP que edita los campos del beneficiario>
-- =============================================
ALTER PROCEDURE [dbo].[sp_editarBeneficiario]

    @IdPersona INT,
    @CuentaId INT,
    @NuevoNombre VARCHAR(40),
    @ParentescoNombre VARCHAR(40),
    @NuevoPorcentajeBeneficio INT,
    @NuevaFechaNacimiento DATE,
    @NuevoDocumentoIdentificacion VARCHAR(20),
    @NuevoEmail VARCHAR(50),
    @NuevoTelefono1 INT,
    @NuevoTelefono2 INT

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @PorcentajeTotalCuenta INT

    --Variable para manejo de errores (1 si el sp se ejecutó correctamente, 0 si el sp falló)
    DECLARE @Return_Status INT
    SET @Return_Status = 0

    --Se obtiene el porcentaje actual de la cuenta repartido entre los beneficiarios
    SET @PorcentajeTotalCuenta = (SELECT SUM(B.Porcentaje) FROM [dbo].[Beneficiarios] AS B WHERE B.CuentaAsociadaId = @CuentaId AND B.EstaActivo = 1 AND B.PersonaId <> @IdPersona)

    --Se valida que PorcentajeTotalCuenta no sea nulo
    IF (@PorcentajeTotalCuenta IS NULL)
        BEGIN
            SET @PorcentajeTotalCuenta = 0
        END

    --Si el porcentaje de beneficio es mayor que 100
    IF (@PorcentajeTotalCuenta + @NuevoPorcentajeBeneficio <= 100)
        BEGIN

            --Try Catch para manejar errores y almancenarlos en DB_Errores en caso de que ocurran
            BEGIN TRY

                --Cambiar nombre
                UPDATE Persona
                SET Nombre = @NuevoNombre
                WHERE Id = @IdPersona

                --Cambiar parentesco
                UPDATE Beneficiarios
                SET ParentescoId = (SELECT Id FROM [dbo].[Parentescos] AS PA WHERE @ParentescoNombre = PA.Nombre)
                WHERE PersonaId = @IdPersona

                --Cambiar porcentaje de beneficio
                UPDATE Beneficiarios
                SET Porcentaje = @NuevoPorcentajeBeneficio
                WHERE PersonaId = @IdPersona

                --Cambiar fechaNacimiento
                UPDATE Persona
                SET FechaNacimiento = @NuevaFechaNacimiento
                WHERE Id = @IdPersona

                --Cambiar DocIdentificación
                UPDATE Persona
                SET ValorDocumentoIdentidadDelCliente = @NuevoDocumentoIdentificacion
                WHERE Id = @IdPersona

                --Cambiar email
                UPDATE Persona
                SET Email = @NuevoEmail
                WHERE Id = @IdPersona

                --Cambiar telefono 1
                UPDATE Persona
                SET Telefono1 = @NuevoTelefono1
                WHERE Id = @IdPersona

                --Cambiar telefono 2
                UPDATE Persona
                SET Telefono2 = @NuevoTelefono2
                WHERE Id = @IdPersona

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

    RETURN @Return_Status

END
