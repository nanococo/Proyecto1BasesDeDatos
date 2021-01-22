SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Brayan Marín Quirós>
-- Create date: <21/01/2021>
-- Description:	<Sp que simula qué pasaría si todos los ahorrantes fallecieran>
-- =============================================
ALTER PROCEDURE sp_ObtenerDineroBeneficiarios

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;


    --Si todos los ahorrantes se murieran, debe listar los beneficiarios,
    --el monto del dinero que recibirá, el código de la cuenta que
    --aporta mayor cantidad de beneficio, y la cantidad de cuentas de las que recibirá el dinero,
    --debe lisar en orden descendente de monto del dinero que recibirá.

    --Tabla temporal que dará todos los datos de las consultas
    DECLARE @Temp TABLE (
                            Id INT IDENTITY(1,1),
                            IdBeneficiario INT,
                            MontoARecibir MONEY,
                            CuentaMayorBeneficio INT,
                            MontoMayor MONEY,
                            CantidadCuentas INT
                        )

    DECLARE @beneficiarioId INT
    DECLARE @cuentaAhorroId INT
    DECLARE @porcentajeBeneficio INT
    DECLARE @numeroCuenta INT
    DECLARE @personaId INT

    DECLARE cursor_CO CURSOR
        FOR SELECT [B].[Id], [B].[CuentaAsociadaId], [B].[PersonaId], [B].[Porcentaje]
            FROM [dbo].[Beneficiarios] AS B
            WHERE [B].[EstaActivo] = 1

    OPEN cursor_CO
    FETCH NEXT FROM cursor_CO INTO
        @beneficiarioId,
        @cuentaAhorroId,
        @personaId,
        @porcentajeBeneficio;

    WHILE @@FETCH_STATUS = 0
        BEGIN

            DECLARE @MontoTotal MONEY = 0
            DECLARE @MontoCuenta MONEY = 0
            DECLARE @CantidadCuentas INT

            --Obtener numero de cuenta
            SET @numeroCuenta = (
                SELECT [CA].[NumeroCuenta]
                FROM [dbo].[CuentaAhorros] AS CA
                WHERE [CA].[Id] = @cuentaAhorroId
            )

            --Se obtiene la cantidad de cuentas de las que se recibirán dinero
            SET @CantidadCuentas = (
                SELECT COUNT (*)
                FROM [dbo].[Beneficiarios] AS B
                WHERE [B].[PersonaId] = @personaId
                  AND [B].[EstaActivo] = 1
            )

            --Se obtiene el monto de la cuenta
            SET @MontoCuenta = (
                SELECT [CA].[Saldo]
                FROM [dbo].[CuentaAhorros] AS CA
                WHERE [CA].[ID] = @cuentaAhorroId
            )

            --Se calcula el monto total a recibir de una cuenta
            SET @MontoTotal = ((@MontoCuenta * @porcentajeBeneficio)/100)

            --Si ya se ha insertado el beneficiario
            IF EXISTS (
                    SELECT [ID] FROM @Temp AS T
                    WHERE [T].[IdBeneficiario] = @beneficiarioId
                )
                BEGIN

                    --Si el monto de la cuenta es mayor al monto mayor del registro, se actualiza
                    IF (@MontoTotal > (
                        SELECT [T].[MontoMayor]
                        FROM @Temp AS T
                        WHERE IdBeneficiario = @beneficiarioId
                    )
                        )

                        BEGIN

                            --Actualiza el monto mayor de la cuenta y el número de cuenta que da mayor beneficio
                            UPDATE @Temp
                            SET MontoMayor = @MontoTotal,
                                CuentaMayorBeneficio = @numeroCuenta
                            WHERE IdBeneficiario = @beneficiarioId

                        END

                    --Actualiza el monto que recibirá el beneficiario
                    UPDATE @Temp
                    SET MontoARecibir = MontoARecibir + @MontoTotal
                    WHERE IdBeneficiario = @beneficiarioId

                END

                --Si no se ha insertado el beneficiario
            ELSE
                BEGIN

                    INSERT INTO @Temp (
                        [IdBeneficiario],
                        [MontoARecibir],
                        [CuentaMayorBeneficio],
                        [MontoMayor],
                        [CantidadCuentas]
                    )
                    VALUES (
                               @beneficiarioId,
                               @MontoTotal,
                               @numeroCuenta,
                               @MontoTotal,
                               @CantidadCuentas
                           )

                END

            FETCH NEXT FROM cursor_CO INTO
                @beneficiarioId,
                @cuentaAhorroId,
                @personaId,
                @porcentajeBeneficio;

        END

    CLOSE cursor_CO
    DEALLOCATE cursor_CO

    --Select final
    SELECT [T].[IdBeneficiario],
           [T].[MontoARecibir],
           [T].[CuentaMayorBeneficio],
           [T].[CantidadCuentas]
    FROM @Temp AS T
    ORDER BY [T].[MontoARecibir] DESC

END
GO
