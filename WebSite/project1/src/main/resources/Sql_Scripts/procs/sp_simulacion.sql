USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_simulacion]    Script Date: 20/01/2021 7:30:55 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sebastian Alpizar
-- Create date: 10/01/21
-- Description:	Este documento procesa la insercion de datos
-- =============================================
ALTER PROCEDURE [dbo].[sp_simulacion]
    -- Add the parameters for the stored procedure here

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    BEGIN TRY

        --Declaracion de variables

        DECLARE @fechaInicio DATE
        DECLARE @fechaFin DATE


        --Lectura del XML
        DECLARE @x XML

        SELECT @x = D
        FROM OPENROWSET (BULK 'C:\TestData\Datos-Tarea3.xml', SINGLE_BLOB) AS Datos(D)

        DECLARE @hdoc INT

        EXEC sp_xml_preparedocument @hdoc OUTPUT, @x

        --Set dates to loop trough
        SET @fechaInicio =	(
            SELECT TOP 1 [Fecha]
            FROM OPENXML (@hdoc, 'Operaciones/FechaOperacion', 1)
                          WITH ([Fecha] DATE)
        )

        SET @fechaFin = GETDATE()


        WHILE @fechaInicio <= @fechaFin
            BEGIN

                IF EXISTS (SELECT [Fecha] FROM OPENXML(@hdoc, 'Operaciones/FechaOperacion',1) WITH ([Fecha] DATE) WHERE [Fecha] = @fechaInicio)
                    BEGIN

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
                        WHERE [Fecha] = @fechaInicio


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
                        WHERE [Fecha] = @fechaInicio


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
                        WHERE [Fecha] = @fechaInicio


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
                        WHERE [Fecha] = @fechaInicio


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
                        WHERE [Fecha] = @fechaInicio


                        --INSERT DE USUARIOS VER
                        INSERT INTO [dbo].[UsuariosVer] ([UserId], [CuentaId])
                        SELECT U.Id AS UserId, CA.Id AS CuentaAhorrosId
                        FROM OPENXML (@hdoc, 'Operaciones/FechaOperacion/UsuarioPuedeVer', 1)
                                      WITH ([Fecha] DATE '../@Fecha', [User] VARCHAR(50), [NumeroCuenta] INT) AS D
                                 INNER JOIN [dbo].[Usuarios] AS U
                                            ON D.[User] = U.Username
                                 INNER JOIN [dbo].[CuentaAhorros] AS CA
                                            ON CA.NumeroCuenta = D.NumeroCuenta
                        WHERE [Fecha] = @fechaInicio


                        --INSERT CUENTA OBJETIVO
                        INSERT INTO [dbo].[CuentaObjetivo] (
                            [CuentaAhorrosId],
                            [FechaInicio],
                            [FechaFin],
                            [DiaAhorro],
                            [MontoAhorro],
                            [Descripcion]
                        )

                        SELECT	C.[Id],
                                  [FechaInicio],
                                  [FechaFinal],
                                  [DiaAhorro],
                                  [MontoAhorro],
                                  [Descripcion]

                        FROM OPENXML (@hdoc, 'Operaciones/FechaOperacion/CuentaAhorro', 1)
                                      WITH (	[Fecha] DATE '../@Fecha',
                                          [NumeroCuentaPrimaria] INT,
                                          [FechaInicio] DATE '../@Fecha',
                                          [FechaFinal] DATE,
                                          [DiaAhorro] INT,
                                          [MontoAhorro] INT,
                                          [Descripcion] VARCHAR(50)) AS D
                                 INNER JOIN [dbo].[CuentaAhorros] as C
                                            ON D.[NumeroCuentaPrimaria] = C.NumeroCuenta
                        WHERE [Fecha] = @fechaInicio


                        ---------------------FIN DE LA INCERCIÓN DE DATOS---------------------

                    END

                ---------------------INICIO DEL PROCESO DE CUENTA OBJETIVO---------------------


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

                        --Proceso de Intereses
                        DECLARE @fechaDeInicioCO DATE = (SELECT fechaInicio FROM [dbo].[CuentaObjetivo] WHERE Id = @cuentaObjetivoId)
                        DECLARE @fechaDeFinCO DATE = (SELECT FechaFin FROM [dbo].[CuentaObjetivo] WHERE Id = @cuentaObjetivoId)
                        DECLARE @saldoCO MONEY = (SELECT SaldoCO FROM [dbo].[CuentaObjetivo] WHERE Id = @cuentaObjetivoId)

                        IF @fechaInicio < @fechaDeFinCO
                            BEGIN

                                DECLARE @mesesEntreFechas INT = CAST(ROUND(ABS(DATEDIFF(MONTH, @fechaDeInicioCO, @fechaDeFinCO)), 0) AS INT)
                                DECLARE @porcentajeInteres FLOAT = (0.5 * @mesesEntreFechas)/365

                                DECLARE @interesAcumulado MONEY = (SELECT InteresAcumulado FROM [dbo].[CuentaObjetivo] WHERE Id = @cuentaObjetivoId)
                                DECLARE @interesAgregado MONEY = @interesAcumulado + (@saldoCO * @porcentajeInteres)

                                IF @interesAgregado > 0
                                    BEGIN

                                        BEGIN TRANSACTION ActualizarIntereses

                                            UPDATE [dbo].[CuentaObjetivo]
                                            SET InteresAcumulado = @interesAgregado
                                            WHERE Id = @cuentaObjetivoId

                                            INSERT INTO [dbo].[MovimientosInteresCO] (CuentaObjetivoId, TipoMovInteresCO, Fecha, Monto, Descripcion)
                                            VALUES (@cuentaObjetivoId, 2, @fechaInicio, @interesAcumulado, 'Interes Diario')

                                        COMMIT TRANSACTION ActualizarIntereses

                                    END


                            END

                        --Proceso del Ahorro
                        IF DATEPART(DAY, @fechaInicio) = (SELECT DiaAhorro FROM [dbo].[CuentaObjetivo] WHERE Id = @cuentaObjetivoId) AND @fechaInicio < @fechaDeFinCO
                            BEGIN


                                DECLARE @montoActual MONEY = (SELECT Saldo FROM [dbo].[CuentaAhorros] WHERE Id = @cuentaAhorroId)
                                DECLARE @montoAhorro MONEY = (SELECT MontoAhorro FROM [dbo].[CuentaObjetivo] WHERE Id = @cuentaObjetivoId)


                                IF @montoActual-@montoAhorro > 0
                                    BEGIN

                                        BEGIN TRANSACTION UpdateCuentaObjetivoValues

                                            UPDATE [dbo].[CuentaAhorros]
                                            SET Saldo = (@montoActual - @montoAhorro)
                                            WHERE Id = @cuentaAhorroId

                                            UPDATE [dbo].[CuentaObjetivo]
                                            SET SaldoCO = (@saldoCO + @montoAhorro)
                                            WHERE Id = @cuentaObjetivoId

                                            INSERT INTO [dbo].[MovimientosCO] (CuentaObjetivoId, TipoMovCO, Fecha, Monto, NuevoSaldo)
                                            VALUES (@cuentaObjetivoId, 1, @fechaInicio, @montoAhorro, (@saldoCO + @montoAhorro))

                                        COMMIT TRANSACTION UpdateCuentaObjetivoValues

                                    END

                            END
                            ELSE
                            BEGIN

                                IF @fechaInicio = (SELECT FechaFin FROM [dbo].[CuentaObjetivo] WHERE Id = @cuentaObjetivoId)
                                    BEGIN

                                        DECLARE @interesesAcumulados MONEY = (SELECT InteresAcumulado FROM [dbo].[CuentaObjetivo] WHERE Id = @cuentaObjetivoId)
                                        DECLARE @saldoActual MONEY = (SELECT SaldoCO FROM [dbo].[CuentaObjetivo] WHERE Id = @cuentaObjetivoId)
                                        DECLARE @nuevoSaldo MONEY = @interesesAcumulados + @saldoActual
                                        DECLARE @saldoCA MONEY = (SELECT Saldo FROM [dbo].[CuentaAhorros] WHERE ID = @cuentaAhorroId)


                                        BEGIN TRANSACTION CerrarCO

                                            UPDATE [dbo].[CuentaObjetivo]
                                            SET InteresAcumulado = 0, SaldoCO = 0, Activo = 0
                                            WHERE Id = @cuentaObjetivoId

                                            UPDATE [dbo].[CuentaAhorros]
                                            SET Saldo = (@saldoCA + @nuevoSaldo)
                                            WHERE Id = @cuentaAhorroId

                                            INSERT INTO [dbo].[MovimientosCO] (CuentaObjetivoId, TipoMovCO, Fecha, Monto, NuevoSaldo)
                                            VALUES (@cuentaObjetivoId, 3, @fechaInicio, @saldoActual, 0)


                                        COMMIT TRANSACTION CerrarCO

                                    END

                            END


                        FETCH NEXT FROM cursor_CO INTO
                            @cuentaObjetivoId,
                            @cuentaAhorroId
                    END

                CLOSE cursor_CO
                DEALLOCATE cursor_CO




                SET @fechaInicio = DATEADD(dd,1,@fechaInicio)

            END

        EXEC sp_xml_removedocument @hdoc



    END TRY

    BEGIN CATCH

        DECLARE @xstate INT

        SELECT @xstate = XACT_STATE();

        IF @xstate = -1
            ROLLBACK;
        IF @xstate = 1
            ROLLBACK

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