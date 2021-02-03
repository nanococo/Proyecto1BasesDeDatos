USE [CompetenciaCiclistica]
GO
/****** Object:  StoredProcedure [dbo].[sp_simulacion]    Script Date: 02/02/2021 3:10:05 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sebastian Alpizar
-- Create date: 02/02/21
-- Description:	Este documento procesa la insercion de datos
-- =============================================
ALTER PROCEDURE [dbo].[sp_operaciones]
    -- Add the parameters for the stored procedure here

AS
BEGIN
            LINENO 0
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    BEGIN TRY

        --Declaracion de variables

        DECLARE @operationYearStart INT
        DECLARE @operationYearEnd INT


        --Lectura del XML
        DECLARE @x XML

        SELECT @x = D
        FROM OPENROWSET (BULK 'C:\TestData\FinalDataXML.xml', SINGLE_BLOB) AS Datos(D)

        DECLARE @hdoc INT

        EXEC sp_xml_preparedocument @hdoc OUTPUT, @x

        --Set dates to loop trough
        SET @operationYearStart =	(
            SELECT TOP 1 [Id]
            FROM OPENXML (@hdoc, 'Root/Year', 1)
                          WITH ([Id] INT)
        )

        --Año de fin
        SET @operationYearEnd = DATEPART(YEAR, GETDATE())

        --Se inicia la iteracion de fechas
        WHILE @operationYearStart <= @operationYearEnd
            BEGIN

                DECLARE @tempGiroEquipo TABLE (
                                                  Id INT IDENTITY(1,1),
                                                  IdInstanciaGiro INT,
                                                  IdEquipo INT
                                              )

                DECLARE @FinalCorredoresEnCarrera TABLE (
                                                            Id INT IDENTITY (1,1),
                                                            IdCarrera INT,
                                                            NumeroCamisa INT,
                                                            HoraLlegada TIME(7)
                                                        )

                DECLARE @premiosMontanaTemp TABLE (
                                                      Id INT IDENTITY (1,1),
                                                      IdCarrera INT,
                                                      NombrePremio VARCHAR(50),
                                                      NumeroCamisa INT
                                                  )

                --Filtro para solo insertar si la fecha existe en el XML
                IF EXISTS (SELECT [Id] FROM OPENXML(@hdoc, 'Root/Year',1) WITH ([Id] INT) WHERE [Id] = @operationYearStart)
                    BEGIN

                        --Insertar Instancia de Giro
                        INSERT INTO [dbo].[InstanciaGiro] (
                            [IdGiro],
                            [Anno],
                            [CodigoInstancia],
                            [FechaInicio],
                            [FechaFin]
                        )
                        SELECT	[IdGiro],
                                  [Anno],
                                  [CodigoInstancia],
                                  [FechaInicio],
                                  [FechaFin]
                        FROM OPENXML (@hdoc, 'Root/Year/InstanciaGiro', 1)
                                      WITH (
                                          [Id] INT '../@Id',
                                          [IdGiro] INT,
                                          [Anno] INT '../@Id',
                                          [CodigoInstancia] VARCHAR(50),
                                          [FechaInicio] DATE,
                                          [FechaFin] DATE
                                          )
                        WHERE [Id] = @operationYearStart


                        --Insertar GiroXEquipo
                        INSERT INTO [dbo].[InstanciaGiroXEquipo](
                            [IdInstanciaGiro],
                            [IdEquipo]
                        )
                        SELECT	G.[Id],
                                  [Equipo]
                        FROM OPENXML (@hdoc, 'Root/Year/InstanciaGiro/GiroXEquipo', 1)
                                      WITH(
                                          [Id] INT '../../@Id',
                                          [CodigoInstanciaGiro] VARCHAR(50),
                                          [Equipo] INT
                                          ) AS D
                                 INNER JOIN [dbo].[InstanciaGiro] AS G
                                            ON D.[CodigoInstanciaGiro] = G.[CodigoInstancia]
                        WHERE D.[Id] = @operationYearStart


                        INSERT INTO @tempGiroEquipo (
                            [IdInstanciaGiro],
                            [IdEquipo]
                        )
                        SELECT	G.[Id],
                                  [Equipo]
                        FROM OPENXML (@hdoc, 'Root/Year/InstanciaGiro/GiroXEquipo', 1)
                                      WITH(
                                          [Id] INT '../../@Id',
                                          [CodigoInstanciaGiro] VARCHAR(50),
                                          [Equipo] INT
                                          ) AS D
                                 INNER JOIN [dbo].[InstanciaGiro] AS G
                                            ON D.[CodigoInstanciaGiro] = G.[CodigoInstancia]
                        WHERE D.[Id] = @operationYearStart


                        --Insertar CorredoresEnEquipoEnGiro
                        INSERT INTO [dbo].[CorredoresEnEquipoEnGiro] (
                            [IdInstanciaGiro],
                            [IdEquipo],
                            [IdCorredor],
                            [NumeroCamisa]
                        )
                        SELECT	G.[Id],
                                  [Equipo],
                                  [Corredor],
                                  [NumeroCamisa]
                        FROM OPENXML (@hdoc, 'Root/Year/InstanciaGiro/CorredoresEnEquipoEnGiro', 1)
                                      WITH(
                                          [Id] INT '../../@Id',
                                          [CodigoInstanciaGiro] VARCHAR(50),
                                          [Equipo] INT,
                                          [Corredor] INT,
                                          [NumeroCamisa] INT
                                          ) AS D
                                 INNER JOIN [dbo].[InstanciaGiro] AS G
                                            ON D.[CodigoInstanciaGiro] = G.[CodigoInstancia]
                        WHERE D.[Id] = @operationYearStart


                        --Insertar Carrera
                        INSERT INTO [dbo].[Carrera] (
                            [IdInstanciaGiro],
                            [CodigoCarrera],
                            [IdEtapa],
                            [FechaCarrera],
                            [HoraInicio]
                        )
                        SELECT	G.[Id],
                                  [CodigoCarrera],
                                  [IdEtapa],
                                  [FechaCarrera],
                                  [HoraInicio]
                        FROM OPENXML (@hdoc, 'Root/Year/InstanciaGiro/Carrera', 1)
                                      WITH(
                                          [Id] INT '../../@Id',
                                          [CodigoInstanciaGiro] VARCHAR(50),
                                          [CodigoCarrera] VARCHAR(50),
                                          [IdEtapa] INT,
                                          [FechaCarrera] DATE,
                                          [HoraInicio] TIME(7)
                                          ) AS D
                                 INNER JOIN [dbo].[InstanciaGiro] AS G
                                            ON D.[CodigoInstanciaGiro] = G.[CodigoInstancia]
                        WHERE D.[Id] = @operationYearStart



                        --Insert FinalCorredoresEnCarrera temp
                        INSERT INTO @FinalCorredoresEnCarrera (
                            [IdCarrera],
                            [NumeroCamisa],
                            [HoraLlegada]
                        )
                        SELECT	C.[Id],
                                  [NumeroCamisa],
                                  [HoraLlegada]
                        FROM OPENXML (@hdoc, 'Root/Year/InstanciaGiro/FinalCorredoresEnCarrera', 1)
                                      WITH(
                                          [Id] INT '../../@Id',
                                          [CodigoCarrera] VARCHAR(50),
                                          [NumeroCamisa] INT,
                                          [HoraLlegada] TIME(7)
                                          ) AS D
                                 INNER JOIN [dbo].[Carrera] as C
                                            ON D.[CodigoCarrera] = C.[CodigoCarrera]
                        WHERE D.[Id] = @operationYearStart

                        --Insert FinalCorredoresEnCarrera final
                        INSERT INTO [dbo].[FinalCorredoresEnCarrera] (
                            [IdCarrera],
                            [NumeroCamisa],
                            [HoraLlegada]
                        )
                        SELECT	[IdCarrera],
                                  [NumeroCamisa],
                                  [HoraLlegada]
                        FROM @FinalCorredoresEnCarrera


                        --Insert GanadorPremioMontanaEnCarrera temp
                        INSERT INTO @premiosMontanaTemp (
                            [IdCarrera],
                            [NombrePremio],
                            [NumeroCamisa]
                        )
                        SELECT	C.[Id],
                                  [NombrePremio],
                                  [NumeroCamisa]
                        FROM OPENXML (@hdoc, 'Root/Year/InstanciaGiro/GanadorPremioMontanaEnCarrera', 1)
                                      WITH(
                                          [Id] INT '../../@Id',
                                          [CodigoCarrera] VARCHAR(50),
                                          [NombrePremio] VARCHAR(50),
                                          [NumeroCamisa] INT
                                          ) AS D
                                 INNER JOIN [dbo].[Carrera] as C
                                            ON D.[CodigoCarrera] = C.[CodigoCarrera]
                        WHERE D.[Id] = @operationYearStart

                        --Insert GanadorPremioMontanaEnCarrera fin
                        INSERT INTO [dbo].[GanadorPremioMontanaEnCarrera](
                            [IdCarrera],
                            [NombrePremio],
                            [NumeroCamisa]
                        )
                        SELECT	[IdCarrera],
                                  [NombrePremio],
                                  [NumeroCamisa]
                        FROM @premiosMontanaTemp


                        --Insertar SancionCarrera
                        INSERT INTO [dbo].[SancionCarrera] (
                            [IdCarrera],
                            [IdJuez],
                            [NumeroCamisa],
                            [MinutosCastigo],
                            [Descripcion]
                        )
                        SELECT	C.[Id],
                                  [IdJuez],
                                  [NumeroCamisa],
                                  [MinutosCastigo],
                                  [Descripcion]
                        FROM OPENXML (@hdoc, 'Root/Year/InstanciaGiro/SancionCarrera', 1)
                                      WITH(
                                          [Id] INT '../../@Id',
                                          [CodigoCarrera] VARCHAR(50),
                                          [IdJuez] INT,
                                          [NumeroCamisa] INT,
                                          [MinutosCastigo] INT,
                                          [Descripcion] VARCHAR(50)
                                          ) AS D
                                 INNER JOIN [dbo].[Carrera] as C
                                            ON D.[CodigoCarrera] = C.[CodigoCarrera]
                        WHERE D.[Id] = @operationYearStart

                        ---------------------FIN DE LA INCERCIÓN DE DATOS---------------------

                    END
                SET @operationYearStart = (@operationYearStart + 1)

                DELETE FROM @tempGiroEquipo
                DELETE FROM @FinalCorredoresEnCarrera

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
