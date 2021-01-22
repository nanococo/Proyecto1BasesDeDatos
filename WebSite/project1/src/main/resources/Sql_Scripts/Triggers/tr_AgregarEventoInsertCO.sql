USE [Banco]
GO

/****** Object:  Trigger [dbo].[tr_AgregarEventoInsertCO]    Script Date: 20/1/2021 19:50:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	<Brayan Marín Quirós>
-- Create date: <18/01/2021>
-- Description:	<Trigger que agrega un evento cuando se inserta una cuenta objetivo>
-- =============================================
CREATE TRIGGER [dbo].[tr_AgregarEventoInsertCO]
   ON  [dbo].[CuentaObjetivo]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     --Variables
	DECLARE @IP_Address VARCHAR(255)
	DECLARE @FechaEvento DATE 
	DECLARE @IdUsuario INT
	DECLARE @XML VARCHAR(255)
	
	--Variables de un registro
	DECLARE @IdTabla INT
	DECLARE @COID INT
	DECLARE @CuentaAhorrosAsociadaId INT

	--Declaracion tabla temporal para guardar CO insertados
    DECLARE @Temp 
	TABLE (
		   Id INT IDENTITY(1,1), 
		   COId INT, 
		   CuentaAhorrosAsociadaId INT
		  )

	--Insercion en tabla temporal para guardar movimientos
	INSERT INTO @Temp ([COId], [CuentaAhorrosAsociadaId])
	SELECT [I].[Id], [I].[CuentaAhorrosId]
	FROM inserted AS I

	--Setea ip
	SELECT @IP_Address = client_net_address    
	FROM sys.dm_exec_connections    
	WHERE Session_id = @@SPID

	----Setea fecha del evento
    SET @FechaEvento = GETDATE()
	SET @FechaEvento = CONVERT(VARCHAR, @FechaEvento, 21)

	--Try Catch para manejar errores y almancenarlos en DB_Errores en caso de que ocurran
	BEGIN TRY
		
		--Contador para el while
		DECLARE @Contador INT

		--Setea el contador con la cantidad total de movimientos en la tabla
		SET @Contador = (SELECT count(*) FROM @Temp)

		--While que recorre los movimientos insertados
		WHILE @Contador > 0
		BEGIN

			--Selección de datos del registro
			SET @IdTabla = (SELECT TOP(1) [T].[Id] 
							FROM @Temp AS T 
							ORDER BY [T].[Id] ASC)

			SET @COID = (SELECT TOP(1) [T].[COId] 
						FROM @Temp AS T 
						ORDER BY [T].[Id] ASC)

			SET @CuentaAhorrosAsociadaId= (SELECT TOP(1) [T].[CuentaAhorrosAsociadaId] 
										   FROM @Temp AS T 
										   ORDER BY [T].[Id] ASC
										  )

			--Elimina la fila del movimiento procesado y así poder actualizar el contador al final del while
			DELETE @Temp WHERE Id = @IdTabla
			
			--Se actualiza el contador según la cantidad restante de registros en la tabla temporal
			SET @Contador = (SELECT count(*) FROM @Temp)

			--Obtener IdUsuario
			SET @IdUsuario = (
							  SELECT [U].[Id]
							  FROM [dbo].[CuentaAhorros] AS CA 
							  INNER JOIN [dbo].[Usuarios] AS U
							  ON [CA].[PersonaId] = [U].[PersonaId]
							  WHERE [CA].[Id] = @CuentaAhorrosAsociadaId
							 )

			--Obtener XML
			SET @XML = (
						SELECT * 
						FROM inserted AS CuentaObjetivo 
						WHERE [CuentaObjetivo].[Id] = @COID 
						for XML AUTO 
				       )

			--Insert del nuevo evento
			INSERT 
			INTO [dbo].[Eventos] ( 
								  [IdTipoEvento], 
								  [IdUser], 
								  [IP],
								  [Fecha],
								  [XMLAntes],
								  [XMLDespues]
								 )
			VALUES (
					4,
					@IdUsuario,
					@IP_Address,
					@FechaEvento,
					'',
					@XML
				   )
		END -- end del while

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

GO

ALTER TABLE [dbo].[CuentaObjetivo] ENABLE TRIGGER [tr_AgregarEventoInsertCO]
GO


