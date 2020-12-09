USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_cargarOperaciones]    Script Date: 08/12/2020 9:25:26 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Brayan Marín Quirós>
-- Create date: <1/12/2020>
-- Description:	<Sp que carga las operaciones>
-- =============================================
ALTER PROCEDURE [dbo].[sp_cargarOperaciones]

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    --Lectura del XML
    DECLARE @x XML

    SELECT @x = D
    FROM OPENROWSET (BULK 'C:\TestData\Datos_Tarea_2.xml', SINGLE_BLOB) AS Datos(D)

    DECLARE @hdoc INT

    EXEC sp_xml_preparedocument @hdoc OUTPUT, @x

    --Declaracion tabla temporal para guardar fechas
    DECLARE @FechasProcesar TABLE (Id INT IDENTITY(1,1), Fecha DATE)

    --Insercion en tabla temporal para guardar fechas
    INSERT INTO @FechasProcesar
    SELECT *
    FROM OPENXML (@hdoc, 'Operaciones/FechaOperacion', 1)
                  WITH ([Fecha] DATE)

    --Variable que obtiene la cantidad de filas en la tabla temporal
    DECLARE @Contador INT = (SELECT count(*) FROM @FechasProcesar)

    --While que recorre las fechas guardadas en la tabla temporal
    WHILE @Contador > 0
        BEGIN

            --Seleccionar fecha
            DECLARE @Fecha DATE = (SELECT TOP(1) Fecha FROM @FechasProcesar ORDER BY Id ASC)
            DECLARE @Id INT = (SELECT TOP(1) Id FROM @FechasProcesar ORDER BY Id ASC)

            --Elimina la fila de la fecha procesada y así poder actualizar el contador al final del while
            DELETE @FechasProcesar WHERE Id = @Id

            --INSERT DE PERSONAS
            INSERT INTO [dbo].[Persona]  (
                [ValorDocumentoIdentidadDelCliente],
                [TipoDocIdentidadId],
                [Nombre],
                [FechaNacimiento],
                [Email],
                [Telefono1],
                [Telefono2]
            )
            SELECT [ValorDocumentoIdentidad],
                   [TipoDocuIdentidad],
                   [Nombre],
                   [FechaNacimiento],
                   [Email],
                   [Telefono1],
                   [Telefono2]
            FROM OPENXML (@hdoc, 'Operaciones/FechaOperacion/Persona', 1)
                          WITH ([Fecha] DATE '../@Fecha',
                              [ValorDocumentoIdentidad] VARCHAR(20),
                              [TipoDocuIdentidad] INT,
                              [Nombre] VARCHAR(40),
                              [FechaNacimiento] DATE,
                              [Email] VARCHAR(50),
                              [Telefono1] INT,
                              [Telefono2] INT)
            WHERE [Fecha] = @Fecha


            --INSERT DE CUENTAS
            INSERT
            INTO [dbo].[CuentaAhorros]  (
                [NumeroCuenta],
                [PersonaId],
                [TipoCuentaId],
                [FechaCreacion]
            )
            SELECT [NumeroCuenta],
                   [P].[Id] AS [PersonaId],
                   [TipoCuentaId],
                   [Fecha]
            FROM OPENXML (@hdoc, 'Operaciones/FechaOperacion/Cuenta', 1)
                          WITH (
                              [Fecha] DATE '../@Fecha',
                              [NumeroCuenta] INT,
                              [ValorDocumentoIdentidadDelCliente] INT,
                              [TipoCuentaId] INT
                              ) AS D
                     INNER JOIN dbo.Persona AS P
                                ON D.ValorDocumentoIdentidadDelCliente = P.ValorDocumentoIdentidadDelCliente
            WHERE [Fecha] = @Fecha

            --INSERT DE BENEFICIARIOS
            INSERT
            INTO [dbo].[Beneficiarios]  (
                [PersonaId],
                [CuentaAsociadaId],
                [Porcentaje],
                [ParentescoId]
            )
            SELECT [P].[Id],
                   [CA].[Id] AS CuentaAsociadaId,
                   [Porcentaje],
                   [ParentezcoId]
            FROM OPENXML (@hdoc, 'Operaciones/FechaOperacion/Beneficiario', 1)
                          WITH ([Fecha] DATE '../@Fecha',
                              [NumeroCuenta] INT,
                              [ValorDocumentoIdentidadBeneficiario] INT,
                              [ParentezcoId] INT,
                              [Porcentaje] INT
                              ) AS D
                     INNER JOIN dbo.CuentaAhorros AS CA
                                ON D.NumeroCuenta = CA.NumeroCuenta
                     INNER JOIN dbo.Persona AS P
                                ON D.ValorDocumentoIdentidadBeneficiario = P.ValorDocumentoIdentidadDelCliente
            WHERE [Fecha] = @Fecha


            --INSERT DE MOVIMIENTOS
            INSERT
            INTO [dbo].[Movimientos]  (
                [CuentaAhorrosId],
                [TipoMovId],
                [Fecha],
                [Monto],
                [Descripcion]
            )
            SELECT [CA].[Id] AS CuentaAhorrosId,
                   [Tipo] AS TipoMovId,
                   [Fecha],
                   [Monto],
                   [Descripcion]
            FROM OPENXML (@hdoc, 'Operaciones/FechaOperacion/Movimientos', 1)
                          WITH ([Fecha] DATE '../@Fecha',
                              [Tipo] INT,
                              [CodigoCuenta] INT,
                              [Monto] MONEY,
                              [Descripcion] VARCHAR(300)
                              ) AS D
                     INNER JOIN dbo.CuentaAhorros AS CA
                                ON D.CodigoCuenta = CA.NumeroCuenta
            WHERE [Fecha] = @Fecha

            --INSERT DE USUARIOS
            INSERT INTO [dbo].[Usuarios] (
                [PersonaId],
                [Username],
                [Password],
                [EsAdmin]
            )
            SELECT Id AS [PersonaId],
                   [User],
                   [Pass],
                   [EsAdministrador]
            FROM OPENXML (@hdoc, 'Operaciones/FechaOperacion/Usuario', 1)
                          WITH (
                              [Fecha] DATE '../@Fecha',
                              [ValorDocumentoIdentidad] INT,
                              [User] VARCHAR(20),
                              [Pass] VARCHAR(50),
                              [EsAdministrador] BIT) AS D
                     INNER JOIN dbo.Persona AS P
                                ON D.ValorDocumentoIdentidad = P.ValorDocumentoIdentidadDelCliente
            WHERE [Fecha] = @Fecha

            --INSERT DE USUARIOS VER
            INSERT INTO [dbo].[UsuariosVer] ([UserId], [CuentaId])
            SELECT U.Id AS UserId, CA.Id AS CuentaAhorrosId
            FROM OPENXML (@hdoc, 'Operaciones/FechaOperacion/UsuarioPuedeVer', 1)
                          WITH ([Fecha] DATE '../@Fecha', [User] VARCHAR(50), [NumeroCuenta] INT) AS D
                     INNER JOIN [dbo].[Usuarios] AS U
                                ON D.[User] = U.Username
                     INNER JOIN [dbo].[CuentaAhorros] AS CA
                                ON CA.NumeroCuenta = D.NumeroCuenta
            WHERE [Fecha] = @Fecha

            --Se actualiza el contador según la cantidad restante de registros en la tabla temporal
            SET @Contador = (SELECT count(*) FROM @FechasProcesar)
        END

    EXEC sp_xml_removedocument @hdoc
END
