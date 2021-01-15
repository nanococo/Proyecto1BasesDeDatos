USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_simulacion]    Script Date: 12/01/2021 6:30:54 pm ******/
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

                        ---------------------FIN DE LA INCERCIÓN DE DATOS---------------------


                        ---------------------INICIO DEL PROCESO DE CIERRE DE ESTADOS DE CUENTA---------------------

                        --El día de cierre es un día después de la fecha de operación
                        DECLARE @DiaCierre INT
                        SET @DiaCierre = DATEPART(DAY,DATEADD(DAY, 1, @fechaInicio))

                        --Tabla que guarda las cuentas a cerrar
                        DECLARE @CuentasACerrar TABLE (
                                                          Id INT IDENTITY(1,1),
                                                          CuentaId INT
                                                      )

                        --Se insertan las cuentas que cerrarán su estado de cuenta
                        INSERT INTO @CuentasACerrar
                        SELECT [CA].[Id] FROM [dbo].[CuentaAhorros] AS CA
                        WHERE DATEPART(DAY, [CA].[FechaCreacion]) = @DiaCierre

                        --Variable que obtiene la cantidad de filas en la tabla temporal @CuentasACerrar
                        DECLARE @ContadorCuentas INT = (SELECT count(*) FROM @CuentasACerrar)

                        --Variables a usar en el while
                        DECLARE @CuentaId INT
                        DECLARE @IdDataAC INT
                        DECLARE @IdEC INT --Id de estado de cuenta
                        DECLARE @FechaFinal DATE

                        --Variables para calcular intereses y comisiones
                        DECLARE @SaldoMinimoCuenta MONEY
                        DECLARE @SaldoMinimoTipoCuenta MONEY
                        DECLARE @InteresGanadoSaldoMinimo MONEY
                        DECLARE @InteresCuenta INT
                        DECLARE @MultaSaldoMinimo MONEY
                        DECLARE @CantOpATM INT
                        DECLARE @CantMaxATM INT
                        DECLARE @ComisionExcesoATM MONEY
                        DECLARE @CantOpVentana INT
                        DECLARE @CantMaxVentana INT
                        DECLARE @ComisionExcesoCH MONEY
                        DECLARE @CargosServicio MONEY

                        --While que recorre las cuentas en la tabla temporal
                        WHILE @ContadorCuentas > 0
                            BEGIN

                                --Información de la tabla temporal

                                --Obtiene el Id de la cuenta de ahorros
                                SET @CuentaId = (SELECT TOP(1) [CAC].[CuentaId]
                                                 FROM @CuentasACerrar AS CAC
                                                 ORDER BY Id ASC)

                                -- Obtiene el id autogenerado de la tabla temporal
                                -- Se usa para eliminar de la tabla temporal ese registro y
                                -- actualizar el contador del while
                                SET @IdDataAC = (SELECT TOP(1) [CAC].[Id]
                                                 FROM @CuentasACerrar AS CAC
                                                 ORDER BY Id ASC)

                                --Obtiene Id del estado de cuenta abierto de @CuentaId
                                SET @IdEC = (
                                    SELECT [Id]
                                    FROM [dbo].[EstadoCuenta] AS EC
                                    WHERE DATEPART(DAY, [EC].[FechaInicio]) = @DiaCierre
                                      AND [EC].[FechaFin] IS NULL
                                      AND [EC].CuentaAhorrosId = @CuentaId
                                )


                                --Creación de la fecha final del estado de cuenta--

                                --Si el día es igual a 1
                                IF (DATEPART(DAY, (
                                    SELECT [EC].[FechaInicio]
                                    FROM  [dbo].[EstadoCuenta] AS EC
                                    WHERE [EC].[Id] = @IdEC))
                                       ) = 1
                                    BEGIN

                                        --Creación de la fecha final para el estado de cuenta
                                        SET @FechaFinal = (
                                            SELECT [EC].[FechaInicio]
                                            FROM  [dbo].[EstadoCuenta] AS EC
                                            WHERE [EC].[Id] = @IdEC
                                        )

                                        --Se obtiene el día final de ese mes
                                        SET @FechaFinal = EOMONTH(@FechaFinal)

                                    END

                                    --Si el día es distinto de uno
                                ELSE
                                    BEGIN
                                        --Creación de la fecha final para el estado de cuenta
                                        --Se resta un día
                                        SET @FechaFinal = DATEADD(DAY, -1, (
                                            SELECT [EC].[FechaInicio]
                                            FROM  [dbo].[EstadoCuenta] AS EC
                                            WHERE [EC].[Id] = @IdEC
                                        )
                                            )

                                        --Se suma un mes
                                        SET @FechaFinal = DATEADD(MONTH, 1 , @FechaFinal)
                                    END



                                --Obtiene el saldo mínimo de la cuenta de ahorros el EC abierto
                                SET @SaldoMinimoCuenta = (
                                    SELECT [EC].[SaldoMinimo]
                                    FROM  [dbo].[EstadoCuenta] AS EC
                                    WHERE [EC].[Id] = @IdEC
                                )

                                --Obtiene el saldo mínimo del tipo de CA con el @CuentaId
                                SET @SaldoMinimoTipoCuenta = (
                                    SELECT [TCA].[SaldoMinimo]
                                    FROM [dbo].[TipoCuentaAhorros] AS TCA
                                    WHERE [TCA].[Id] = (
                                        SELECT [CA].[TipoCuentaId]
                                        FROM [dbo].[CuentaAhorros] AS CA
                                        WHERE [CA].[Id] = @CuentaId
                                    )
                                )

                                --Obtiene la multa saldo mínimo del tipo de CA con el @CuentaId
                                SET @MultaSaldoMinimo = (
                                    SELECT [TCA].[MultaSaldoMin]
                                    FROM [dbo].[TipoCuentaAhorros] AS TCA
                                    WHERE [TCA].[Id] = (
                                        SELECT [CA].[TipoCuentaId]
                                        FROM [dbo].[CuentaAhorros] AS CA
                                        WHERE [CA].[Id] = @CuentaId
                                    )
                                )

                                --Obtiene el interes del tipo de CA con el @CuentaId
                                SET @InteresCuenta = (
                                    SELECT [TCA].[Interes]
                                    FROM [dbo].[TipoCuentaAhorros] AS TCA
                                    WHERE [TCA].[Id] = (
                                        SELECT [CA].[TipoCuentaId]
                                        FROM [dbo].[CuentaAhorros] AS CA
                                        WHERE [CA].[Id] = @CuentaId
                                    )
                                )

                                --Se calcula el interés ganado
                                SET @InteresGanadoSaldoMinimo = (@SaldoMinimoCuenta * @InteresCuenta) / 100

                                --Obtener cantidad de operaciones en ATM del EC
                                SET @CantOpATM = (
                                    SELECT [EC].[CantRetATM]
                                    FROM [dbo].[EstadoCuenta] AS EC
                                    WHERE [EC].[Id] = @IdEC
                                )

                                --Obtener cantidad máxima de operaciones ATM del tipo de CA con el @CuentaId
                                SET @CantMaxATM = (
                                    SELECT [TCA].[NumRetirosAutomatico]
                                    FROM [dbo].[TipoCuentaAhorros] AS TCA
                                    WHERE [TCA].[Id] = (
                                        SELECT [CA].[TipoCuentaId]
                                        FROM [dbo].[CuentaAhorros] AS CA
                                        WHERE [CA].[Id] = @CuentaId
                                    )
                                )

                                --Obtiene la comisión en caso de exceder el límite de retiros en ATM
                                SET @ComisionExcesoATM = (
                                    SELECT [TCA].[ComisionAutomatico]
                                    FROM [dbo].[TipoCuentaAhorros] AS TCA
                                    WHERE [TCA].[Id] = (
                                        SELECT [CA].[TipoCuentaId]
                                        FROM [dbo].[CuentaAhorros] AS CA
                                        WHERE [CA].[Id] = @CuentaId
                                    )
                                )

                                --Obtener cantidad de operaciones en CH del EC
                                SET @CantOpVentana = (
                                    SELECT [EC].[CantRetVentana]
                                    FROM [dbo].[EstadoCuenta] AS EC
                                    WHERE [EC].[Id] = @IdEC
                                )

                                --Obtener cantidad máxima de operaciones en CH del EC
                                SET @CantMaxVentana = (
                                    SELECT [TCA].[NumRetirosHumano]
                                    FROM [dbo].[TipoCuentaAhorros] AS TCA
                                    WHERE [TCA].[Id] = (
                                        SELECT [CA].[TipoCuentaId]
                                        FROM [dbo].[CuentaAhorros] AS CA
                                        WHERE [CA].[Id] = @CuentaId
                                    )
                                )

                                --Obtiene la comisión en caso de exceder el límite de retiros en Cajero Humano
                                SET @ComisionExcesoCH = (
                                    SELECT [TCA].[ComisionHumano]
                                    FROM [dbo].[TipoCuentaAhorros] AS TCA
                                    WHERE [TCA].[Id] = (
                                        SELECT [CA].[TipoCuentaId]
                                        FROM [dbo].[CuentaAhorros] AS CA
                                        WHERE [CA].[Id] = @CuentaId
                                    )
                                )


                                --Obtiene los cargos por servicio de la cuenta

                                SET @CargosServicio = (
                                    SELECT [TCA].[CargoMensual]
                                    FROM [dbo].[TipoCuentaAhorros] AS TCA
                                    WHERE [TCA].[Id] = (
                                        SELECT [CA].[TipoCuentaId]
                                        FROM [dbo].[CuentaAhorros] AS CA
                                        WHERE [CA].[Id] = @CuentaId
                                    )
                                )

                                --Delete para actualizar el contadorCuentas
                                DELETE @CuentasACerrar WHERE Id = @IdDataAC

                                --Se actualiza el contadorCuentas según la cantidad restante de registros en la tabla temporal
                                SET @ContadorCuentas = (SELECT count(*) FROM @CuentasACerrar)

                                -- Inicia la transacción para hacer el cierre de estado de cuenta
                                -- actualizando todos los valores necesarios
                                BEGIN TRANSACTION UpdateEC

                                    --Si el saldo mínimo de la cuenta es mayor o igual al saldo mínimo
                                    --que debe cumplir según el tipo de cuenta entonces aplica un interés ganado
                                    IF (@SaldoMinimoCuenta >= @SaldoMinimoTipoCuenta)
                                        BEGIN
                                            INSERT INTO [dbo].[Movimientos] (
                                                [CuentaAhorrosId],
                                                [TipoMovId],
                                                [Fecha],
                                                [Monto],
                                                [Descripcion]
                                            )
                                            VALUES (
                                                       @CuentaId,
                                                       7,
                                                       @FechaFinal,
                                                       @InteresGanadoSaldoMinimo,
                                                       'Interes ganado por saldo minimo'
                                                   )
                                        END
                                        --Si el saldo de la cuenta es menor al saldo mínimo, aplica multa
                                    ELSE
                                        BEGIN
                                            --Inserta movimiento con débito por incumplimiento de saldo mínimo
                                            INSERT INTO [dbo].[Movimientos] (
                                                [CuentaAhorrosId],
                                                [TipoMovId],
                                                [Fecha],
                                                [Monto],
                                                [Descripcion]
                                            )
                                            VALUES (
                                                       @CuentaId,
                                                       11,
                                                       @FechaFinal,
                                                       @MultaSaldoMinimo,
                                                       'Multa por incumplimiento de saldo minimo'
                                                   )
                                        END

                                    --Cobro por comisión por exceso de CH
                                    IF (@CantOpVentana > @CantMaxVentana)
                                        BEGIN
                                            --Inserta movimiento con multa por exceso de operaciones en cajero humano
                                            INSERT INTO [dbo].[Movimientos] (
                                                [CuentaAhorrosId],
                                                [TipoMovId],
                                                [Fecha],
                                                [Monto],
                                                [Descripcion]
                                            )
                                            VALUES (
                                                       @CuentaId,
                                                       8,
                                                       @FechaFinal,
                                                       @ComisionExcesoCH,
                                                       'Multa por exceso de operaciones en cajero humano'
                                                   )
                                        END

                                    --Cobro por comisión por exceso de operaciones ATM
                                    IF (@CantOpATM > @CantMaxATM)
                                        BEGIN

                                            --Inserta movimiento con multa por exceso de operaciones en cajero automatico'
                                            INSERT INTO [dbo].[Movimientos] (
                                                [CuentaAhorrosId],
                                                [TipoMovId],
                                                [Fecha],
                                                [Monto],
                                                [Descripcion]
                                            )
                                            VALUES (
                                                       @CuentaId,
                                                       9,
                                                       @FechaFinal,
                                                       @ComisionExcesoATM,
                                                       'Multa por exceso de operaciones en cajero automatico'
                                                   )
                                        END


                                    --Inserta movimiento con cobro comisión por cargos de servicio
                                    INSERT INTO [dbo].[Movimientos] (
                                        [CuentaAhorrosId],
                                        [TipoMovId],
                                        [Fecha],
                                        [Monto],
                                        [Descripcion]
                                    )
                                    VALUES (
                                               @CuentaId,
                                               10,
                                               @FechaFinal,
                                               @CargosServicio,
                                               'Comision de cargos por servicio'
                                           )

                                    --Update del saldo final para cerrar la cuenta
                                    UPDATE [dbo].[EstadoCuenta]
                                    SET [dbo].[EstadoCuenta].[SaldoFinal] = (
                                        SELECT [CA].[Saldo]
                                        FROM [dbo].[CuentaAhorros] AS CA
                                        WHERE [CA].[Id] = @CuentaId
                                    )
                                    WHERE [dbo].[EstadoCuenta].[Id] = @IdEC

                                    --Update de la fecha final para cerrar la cuenta
                                    UPDATE [dbo].[EstadoCuenta]
                                    SET [dbo].[EstadoCuenta].[FechaFin] = @FechaFinal
                                    WHERE [dbo].[EstadoCuenta].[Id] = @IdEC


                                    --Insertar nueva instancia de estado de cuenta
                                    INSERT
                                    INTO [dbo].[EstadoCuenta] (
                                        [CuentaAhorrosId],
                                        [FechaInicio],
                                        [SaldoMinimo],
                                        [SaldoInicial]
                                    )
                                    VALUES (
                                               @CuentaId, --CuentaAhorrosId
                                               DATEADD(DAY, 1, @FechaFinal), --FechaInicio
                                               (SELECT [CA].[Saldo]
                                                FROM [dbo].[CuentaAhorros] AS CA
                                                WHERE [CA].[Id] = @CuentaId
                                               ), --SaldoMinimo
                                               (SELECT [CA].[Saldo]
                                                FROM [dbo].[CuentaAhorros] AS CA
                                                WHERE [CA].[Id] = @CuentaId)
                                           )  --SaldoInicial

                                COMMIT TRANSACTION UpdateEC

                            END --End del while de cuentas por cerrar

                        ---------------------FIN DEL PROCESO DE CIERRE DE ESTADOS DE CUENTA---------------------


                    END

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
