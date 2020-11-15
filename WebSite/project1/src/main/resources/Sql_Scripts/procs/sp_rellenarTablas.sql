USE [Banco]
GO
/****** Object:  StoredProcedure [dbo].[sp_rellenarTablas]    Script Date: 14/11/2020 7:27:43 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Brayan Marín>
-- Create date: <07/11/2020>
-- Description:	<SP que rellena todas las tablas desde un archivo XML cargado localmente>
-- =============================================
ALTER PROCEDURE [dbo].[sp_rellenarTablas]

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	--Try Catch para manejar errores y almancenarlos en DB_Errores en caso de que ocurran
	BEGIN TRY

		DECLARE @x xml

		SELECT @x = D
		FROM OPENROWSET (BULK 'C:\TestData\Datos_Tarea1 v2.xml', SINGLE_BLOB) AS Datos(D)

		DECLARE @hdoc INT

		EXEC sp_xml_preparedocument @hdoc OUTPUT, @x

		----Insercion en tabla TipoDocIdentidad
		INSERT INTO dbo.TipoDocIdentidad ([Id], [Nombre])
		SELECT *
		FROM OPENXML (@hdoc, '/Datos/Tipo_Doc/TipoDocuIdentidad', 1)
		WITH ([Id] INT, [Nombre] VARCHAR(20))

		----Insercion en tabla TipoMoneda
		INSERT INTO [dbo].[TipoMoneda] ([Id], [Nombre], [Simbolo])
		SELECT *
		FROM OPENXML (@hdoc, '/Datos/Tipo_Moneda/TipoMoneda', 1)
		WITH ([Id] INT, [Nombre] VARCHAR(20), [Simbolo] VARCHAR(10))

		----Insercion en tabla Parentezcos
		INSERT INTO [dbo].[Parentescos] ([Id], [Nombre])
		SELECT *
		FROM OPENXML (@hdoc, '/Datos/Parentezcos/Parentezco', 1)
		WITH ([Id] INT, [Nombre] VARCHAR(50))

		----Insercion en tabla TipoCuentaAhorros
		INSERT INTO [dbo].[TipoCuentaAhorros] ([Id], [Nombre], [TipoMonedaId], [SaldoMinimo], [MultaSaldoMin], [CargoAnual], [NumRetirosHumano], [NumRetirosAutomatico], [ComisionHumano], [ComisionAutomatico], [Interes])
		SELECT *
		FROM OPENXML (@hdoc, '/Datos/Tipo_Cuenta_Ahorros/TipoCuentaAhorro', 1)
		WITH ([Id] INT, [Nombre] VARCHAR(50), [IdTipoMoneda] INT, [SaldoMinimo] MONEY, [MultaSaldoMin] MONEY, [CargoAnual] MONEY, [NumRetirosHumano] INT, [NumRetirosAutomatico] INT, [ComisionHumano] MONEY, [ComisionAutomatico] MONEY, [Interes] INT)

		----Insercion en tabla Personas
		INSERT INTO [dbo].[Persona] ([ValorDocumentoIdentidadDelCliente], [TipoDocIdentidadId], [Nombre], [FechaNacimiento], [Email], [Telefono1], [Telefono2])
		SELECT *
		FROM OPENXML (@hdoc, '/Datos/Personas/Persona', 1)
		WITH ([ValorDocumentoIdentidad] VARCHAR(20), TipoDocuIdentidad int, [Nombre] VARCHAR(40), [FechaNacimiento] DATE, [Email] VARCHAR(50), [Telefono1] INT, [Telefono2] INT)

		--Insercion en tabla CuentaAhorros
		INSERT INTO [dbo].[CuentaAhorros] ([NumeroCuenta], [PersonaId], [TipoCuentaId], [FechaCreacion], [Saldo])
		SELECT NumeroCuenta, Id AS PersonaId, TipoCuentaId, FechaCreacion, Saldo
		FROM OPENXML (@hdoc, '/Datos/Cuentas/Cuenta', 1)
		WITH ([NumeroCuenta] INT, [ValorDocumentoIdentidadDelCliente] INT,[TipoCuentaId] INT, [FechaCreacion] DATE, [Saldo] MONEY) AS D
		INNER JOIN dbo.Persona AS P
		ON D.ValorDocumentoIdentidadDelCliente = P.ValorDocumentoIdentidadDelCliente

		--Insercion en tabla Beneficiarios
		INSERT INTO [dbo].[Beneficiarios] ([PersonaId], [CuentaAsociadaId], [Porcentaje], [ParentescoId])
		SELECT P.[Id], CA.[Id] AS CuentaAsociadaId, [Porcentaje], [ParentezcoId]
		FROM OPENXML (@hdoc, '/Datos/Beneficiarios/Beneficiario', 1)
		WITH ([NumeroCuenta] INT, [ValorDocumentoIdentidadBeneficiario] INT,[ParentezcoId] INT, [Porcentaje] INT) AS D
		INNER JOIN dbo.CuentaAhorros AS CA
		ON D.NumeroCuenta = CA.NumeroCuenta
		INNER JOIN dbo.Persona AS P
		ON D.ValorDocumentoIdentidadBeneficiario = P.ValorDocumentoIdentidadDelCliente

		--Insercion en tabla EstadoCuenta
		INSERT INTO [dbo].[EstadoCuenta] ([CuentaAhorrosId], [FechaInicio], [FechaFin], [SaldoInicial], [SaldoFinal])
		SELECT Id AS CuentaAhorrosId, fechaInicio, fechaFin, saldoInicial, saldoFinal
		FROM OPENXML (@hdoc, '/Datos/Estados_de_Cuenta/Estado_de_Cuenta', 1)
		WITH (NumeroCuenta INT, fechaInicio DATE, fechaFin DATE, saldoInicial MONEY, saldoFinal MONEY) AS D
		INNER JOIN dbo.CuentaAhorros AS CA
		ON D.NumeroCuenta = CA.NumeroCuenta

		--Insercion en tabla Usuarios
		INSERT INTO [dbo].[Usuarios] ([PersonaId], [Username], [Password], [EsAdmin])
		SELECT Id AS PersonaId, [User], Pass, EsAdministrador
		FROM OPENXML (@hdoc, '/Datos/Usuarios/Usuario', 1)
		WITH ([ValorDocumentoIdentidad] INT, [User] VARCHAR(50), [Pass] VARCHAR(50), [EsAdministrador] BIT) AS D
		INNER JOIN dbo.Persona AS P
		ON D.ValorDocumentoIdentidad = P.ValorDocumentoIdentidadDelCliente

		--Insercion en tabla UsuariosVer
		INSERT INTO [dbo].[UsuariosVer] ([UserId], [CuentaId])
		SELECT U.Id AS UserId, CA.Id AS CuentaAhorrosId
		FROM OPENXML (@hdoc, '/Datos/Usuarios_Ver/UsuarioPuedeVer', 1)
		WITH ([User] VARCHAR(50), NumeroCuenta INT) AS D
		INNER JOIN [dbo].[Usuarios] AS U
		ON D.[User] = U.Username
		INNER JOIN [dbo].[CuentaAhorros] AS CA
		ON CA.NumeroCuenta = D.NumeroCuenta

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
