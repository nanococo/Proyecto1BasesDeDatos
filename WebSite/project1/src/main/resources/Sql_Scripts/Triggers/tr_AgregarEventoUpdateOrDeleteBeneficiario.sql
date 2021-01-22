USE [Banco]
GO

/****** Object:  Trigger [dbo].[tr_AgregarEventoUpdateOrDeleteBeneficiario]    Script Date: 20/1/2021 19:56:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	<Brayan Marín Quirós>
-- Create date: <16/01/2021>
-- Description:	<Trigger que inserta una agrega un evento de eliminado o modificación de beneficiario>
-- =============================================
CREATE TRIGGER [dbo].[tr_AgregarEventoUpdateOrDeleteBeneficiario]
   ON  [dbo].[Beneficiarios]
   FOR UPDATE
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
	DECLARE @XMLAntes VARCHAR(255)
	
	--Variables de un registro
	DECLARE @IdTabla INT
	DECLARE @PersonaIdTemp INT
	DECLARE @CuentaAsociadaIdTemp INT
	DECLARE @EstaActivoTemp BIT

	--Declaracion tabla temporal para guardar movimientos
    DECLARE @Temp 
	TABLE (
		   Id INT IDENTITY(1,1), 
		   PersonaId INT, 
		   CuentaAsociadaId INT,
		   EstaActivo BIT
		  )

	--Insercion en tabla temporal para guardar movimientos
	INSERT INTO @Temp ([PersonaId], [CuentaAsociadaId], [EstaActivo])
	SELECT [I].[PersonaId], [I].[CuentaAsociadaId], [I].[EstaActivo]
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
		select * from @Temp

		--While que recorre los movimientos insertados
		WHILE @Contador > 0
		BEGIN
			
			--Selección de datos del registro
			SET @IdTabla = (SELECT TOP(1) [T].[Id] 
							FROM @Temp AS T 
							ORDER BY [T].[Id] ASC)

			SET @PersonaIdTemp = (SELECT TOP(1) [T].[PersonaId] 
								  FROM @Temp AS T 
								  ORDER BY [T].[Id] ASC)

			SET @CuentaAsociadaIdTemp = (SELECT TOP(1) [T].[CuentaAsociadaId] 
										 FROM @Temp AS T 
										 ORDER BY [T].[Id] ASC)

			SET @EstaActivoTemp = (SELECT TOP(1) [T].[EstaActivo] 
										 FROM @Temp AS T 
										 ORDER BY [T].[Id] ASC)

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
							  WHERE [CA].[Id] = @CuentaAsociadaIdTemp
							 )
	
			--Obtener XML (Después en caso de ser modificación, antes en caos de ser eliminación)
			SET @XML = (
						SELECT * 
						FROM inserted AS Beneficiario 
						WHERE @PersonaIdTemp = [Beneficiario].[PersonaId] 
						for XML AUTO 
				       )

			--Si el beneficiario está activo es porque se están actualizando sus datos
			IF (@EstaActivoTemp = 1) 
			BEGIN

				--Obtener XMLAntes
				SET @XMLAntes = (
								 SELECT * 
								 FROM deleted AS Beneficiario 
								 WHERE @PersonaIdTemp = [Beneficiario].[PersonaId] 
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
						2,
						@IdUsuario,
						@IP_Address,
						@FechaEvento,
						@XMLAntes,
						@XML
					   )
			END
			--Sino, se está eliminando el beneficiario
			ELSE
			BEGIN

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
						3,
						@IdUsuario,
						@IP_Address,
						@FechaEvento,
						@XML,
						''
					   )
			END


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

ALTER TABLE [dbo].[Beneficiarios] ENABLE TRIGGER [tr_AgregarEventoUpdateOrDeleteBeneficiario]
GO


