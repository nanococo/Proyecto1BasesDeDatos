USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_insertarPersona]    Script Date: 08/12/2020 9:30:33 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Brayan Marín>
-- Create date: <14/11/2020>
-- Description:	<SP que inserta una persona.>
-- =============================================
ALTER PROCEDURE [dbo].[sp_insertarPersona]

    @ValorDocumentoIdentidad VARCHAR (20),
    @NombreTipoDoc VARCHAR(40),
    @Nombre VARCHAR(40),
    @FechaNacimiento DATE,
    @Email VARCHAR(50),
    @Telefono1 INT,
    @Telefono2 INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- El Id del tipo de documento es el Id numerico de la tabla
    DECLARE @TipoDocIdentidad INT
    SET @TipoDocIdentidad = (SELECT [Id] FROM [dbo].[TipoDocIdentidad] WHERE [Nombre] = @NombreTipoDoc)

    --Variable para manejo de errores (1 si el sp se ejecutó correctamente, 0 si el sp falló)
    DECLARE @Return_Status INT
    SET @Return_Status = 0

    --Try Catch para manejar errores y almancenarlos en DB_Errores en caso de que ocurran
    BEGIN TRY

        --Insercion en tabla Persona
        INSERT INTO [dbo].[Persona] ([ValorDocumentoIdentidadDelCliente], [TipoDocIdentidadId], [Nombre], [FechaNacimiento], [Email], [Telefono1], [Telefono2])
        VALUES (@ValorDocumentoIdentidad, @TipoDocIdentidad, @Nombre, @FechaNacimiento, @Email, @Telefono1, @Telefono2)
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
