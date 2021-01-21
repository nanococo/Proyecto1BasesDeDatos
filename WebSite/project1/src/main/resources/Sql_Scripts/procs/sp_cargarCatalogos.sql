USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_cargarCatalogos]    Script Date: 20/01/2021 8:12:24 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Brayan Marín Quirós>
-- Create date: <1/12/2020>
-- Description:	<Sp que carga los catálogos>
-- =============================================
ALTER PROCEDURE [dbo].[sp_cargarCatalogos]

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    --Try Catch para manejar errores y almancenarlos en DB_Errores en caso de que ocurran
    BEGIN TRY

        DECLARE @x xml

        SELECT @x = D
        FROM OPENROWSET (BULK 'C:\TestData\Datos-Tarea3-Catalogos.xml', SINGLE_BLOB) AS Datos(D)

        DECLARE @hdoc INT

        EXEC sp_xml_preparedocument @hdoc OUTPUT, @x

        ----Insercion en tabla TipoDocIdentidad
        INSERT
        INTO dbo.TipoDocIdentidad ([Id], [Nombre])
        SELECT [Id], [Nombre]
        FROM OPENXML (@hdoc, '/Catalogos/Tipo_Doc/TipoDocuIdentidad', 1)
                      WITH ([Id] INT, [Nombre] VARCHAR(20))

        ----Insercion en tabla TipoMoneda
        INSERT
        INTO [dbo].[TipoMoneda] ([Id], [Nombre], [Simbolo])
        SELECT [Id], [Nombre], [Simbolo]
        FROM OPENXML (@hdoc, '/Catalogos/Tipo_Moneda/TipoMoneda', 1)
                      WITH ([Id] INT, [Nombre] VARCHAR(20), [Simbolo] VARCHAR(10))

        ----Insercion en tabla Parentezcos
        INSERT
        INTO [dbo].[Parentescos] ([Id], [Nombre])
        SELECT [Id], [Nombre]
        FROM OPENXML (@hdoc, '/Catalogos/Parentezcos/Parentezco', 1)
                      WITH ([Id] INT, [Nombre] VARCHAR(50))

        ----Insercion en tabla TipoCuentaAhorros
        INSERT
        INTO [dbo].[TipoCuentaAhorros] (
            [Id],
            [Nombre],
            [TipoMonedaId],
            [SaldoMinimo],
            [MultaSaldoMin],
            [CargoMensual],
            [NumRetirosHumano],
            [NumRetirosAutomatico],
            [ComisionHumano],
            [ComisionAutomatico],
            [Interes]
        )
        SELECT [Id],
               [Nombre],
               [IdTipoMoneda],
               [SaldoMinimo],
               [MultaSaldoMin],
               [CargoMensual],
               [NumRetiroHumano],
               [NumRetirosAutomatico],
               [ComisionHumano],
               [ComisionAutomatico],
               [Interes]
        FROM OPENXML (@hdoc, '/Catalogos/Tipo_Cuenta_Ahorros/TipoCuentaAhorro', 1)
                      WITH (
                          [Id] INT,
                          [Nombre] VARCHAR(50),
                          [IdTipoMoneda] INT,
                          [SaldoMinimo] MONEY,
                          [MultaSaldoMin] MONEY,
                          [CargoMensual] MONEY,
                          [NumRetiroHumano] INT,
                          [NumRetirosAutomatico] INT,
                          [ComisionHumano] MONEY,
                          [ComisionAutomatico] MONEY,
                          [Interes] INT
                          )

        ----Insercion en tabla TipoMovimientos
        INSERT INTO [dbo].[TipoMovimiento] ([Id], [Nombre], [TipoOperacion])
        SELECT [Id], [Nombre], [Tipo]
        FROM OPENXML (@hdoc, '/Catalogos/Tipo_Movimientos/TipoMovimiento', 1)
                      WITH ([Id] INT, [Nombre] VARCHAR(50), [Tipo] VARCHAR(20))


        --Insercion en tabla TipoMovimientosCO
        INSERT INTO [dbo].[TipoMovimientoCO] ([Id], [Descripcion])
        SELECT [Id], [Nombre]
        FROM OPENXML (@hdoc, '/Catalogos/TiposMovimientoCuentaAhorro/Tipo_Movimiento', 1)
                      WITH ([Id] INT, [Nombre] VARCHAR(50))

        --Insercion en tabla TipoMovimientosCO
        INSERT INTO [dbo].[TipoEvento] ([Id], [Nombre])
        SELECT [Id], [Nombre]
        FROM OPENXML (@hdoc, '/Catalogos/TiposEvento/TipoEvento', 1)
                      WITH ([Id] INT, [Nombre] VARCHAR(50))


        EXEC sp_xml_removedocument @hdoc

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
