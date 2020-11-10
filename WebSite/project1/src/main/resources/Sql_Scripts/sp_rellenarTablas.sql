SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Brayan Marín>
-- Create date: <07/11/2020>
-- Description:	<SP que rellena todas las tablas desde un archivo XML cargado localmente>
-- =============================================
CREATE PROCEDURE sp_rellenarTablas

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @x xml

	SELECT @x = D
	FROM OPENROWSET (BULK 'C:\TestData\Datos_Tarea1.xml', SINGLE_BLOB) AS Datos(D)

	DECLARE @hdoc int

	EXEC sp_xml_preparedocument @hdoc OUTPUT, @x

	----Insercion en tabla TipoDocIdentidad
	INSERT INTO dbo.TipoDocIdentidad ([Id], [Nombre])
	SELECT *
	FROM OPENXML (@hdoc, '/Datos/Tipo_Doc/TipoDocuIdentidad', 1)
	WITH ([Id] int, [Nombre] varchar(50))

	----Insercion en tabla TipoMoneda
	INSERT INTO [dbo].[TipoMoneda] (Id, Nombre, Simbolo)
	SELECT *
	FROM OPENXML (@hdoc, '/Datos/Tipo_Moneda/TipoMoneda', 1)
	WITH ([Id] int, [Nombre] varchar(50), [Simbolo] varchar(10))

	----Insercion en tabla Parentezcos
	INSERT INTO [dbo].[Parentescos] ([Id], [Nombre])
	SELECT *
	FROM OPENXML (@hdoc, '/Datos/Parentezcos/Parentezco', 1)
	WITH ([Id] int, [Nombre] varchar(50))

	----Insercion en tabla TipoCuentaAhorros
	INSERT INTO [dbo].[TipoCuentaAhorros] ([Id], [Nombre], [TipoMonedaId], [SaldoMinimo], [MultaSaldoMin], [CargoAnual], [NumRetirosHumano], [NumRetirosAutomatico], [ComisionHumano], [ComisionAutomatico], [Interes])
	SELECT *
	FROM OPENXML (@hdoc, '/Datos/Tipo_Cuenta_Ahorros/TipoCuentaAhorro', 1)
	WITH ([Id] int, [Nombre] varchar(50), [IdTipoMoneda] int, [SaldoMinimo] money, [MultaSaldoMin] money, [CargoAnual] money, [NumRetirosHumano] int, [NumRetirosAutomatico] int, [ComisionHumano] money, [ComisionAutomatico] money, [Interes] decimal(5,2))

	----Insercion en tabla Personas
	INSERT INTO [dbo].[Persona] ([ValorDocumentoIdentidadDelCliente], [TipoDocIdentidadId], [Nombre], [FechaNacimiento], [Email], [Telefono1], [Telefono2])
	SELECT *
	FROM OPENXML (@hdoc, '/Datos/Personas/Persona', 1)
	WITH ([ValorDocumentoIdentidad] varchar(50), TipoDocuIdentidad int, [Nombre] varchar(100), [FechaNacimiento] date, [Email] varchar(100), [Telefono1] int, [Telefono2] int)

	--Insercion en tabla CuentaAhorros
	INSERT INTO [dbo].[CuentaAhorros] ([NumeroCuenta], [PersonaId], [TipoCuentaId], [FechaCreacion], [Saldo])
	SELECT NumeroCuenta, Id, TipoCuentaId, FechaCreacion, Saldo
	FROM OPENXML (@hdoc, '/Datos/Cuentas/Cuenta', 1) 
	WITH ([NumeroCuenta] int, [ValorDocumentoIdentidadDelCliente] int,[TipoCuentaId] int, [FechaCreacion] date, [Saldo] money) AS D
	INNER JOIN dbo.Persona AS P
	ON D.ValorDocumentoIdentidadDelCliente = P.ValorDocumentoIdentidadDelCliente

	--Insercion en tabla Beneficiarios
	INSERT INTO [dbo].[Beneficiarios] ([PersonaId], [CuentaAsociadaId], [Porcentaje], [ParentescoId])
	SELECT PersonaId, Id as CuentaAsociadaId, Porcentaje, ParentezcoId
	FROM OPENXML (@hdoc, '/Datos/Beneficiarios/Beneficiario', 1) 
	WITH ([NumeroCuenta] int, [ValorDocumentoIdentidadBeneficiario] int,[ParentezcoId] int, [Porcentaje] decimal(5,2)) AS D
	INNER JOIN dbo.CuentaAhorros AS CA
	ON D.NumeroCuenta = CA.NumeroCuenta

	--Insercion en tabla EstadoCuenta
	INSERT INTO [dbo].[EstadoCuenta] ([CuentaAhorrosId], [FechaInicio], [FechaFin], [SaldoInicial], [SaldoFinal])
	SELECT Id AS CuentaAhorrosId, fechaInicio, fechaFin, saldoInicial, saldoFinal
	FROM OPENXML (@hdoc, '/Datos/Estados_de_Cuenta/Estado_de_Cuenta', 1)
	WITH (NumeroCuenta int, fechaInicio date, fechaFin date, saldoInicial money, saldoFinal money) AS D
	INNER JOIN dbo.CuentaAhorros AS CA
	ON D.NumeroCuenta = CA.NumeroCuenta

	--Insercion en tabla Usuarios
	INSERT INTO [dbo].[Usuarios] ([PersonaId], [Username], [Password], [EsAdmin])
	SELECT Id as PersonaId, Usuario, Pass, EsAdministrador
	FROM OPENXML (@hdoc, '/Datos/Usuarios/Usuario', 1)
	WITH ([ValorDocumentoIdentidad] int, [Usuario] varchar(50), [Pass] varchar(50), [EsAdministrador] bit) AS D
	INNER JOIN dbo.Persona AS P
	ON D.ValorDocumentoIdentidad = P.ValorDocumentoIdentidadDelCliente

	--Insercion en tabla UsuariosVer
	INSERT INTO [dbo].[UsuariosVer] ([UserId], [CuentaId])
	SELECT U.Id as UserId, CA.Id as CuentaAhorrosId
	FROM OPENXML (@hdoc, '/Datos/Usuarios_Ver/UsuarioPuedeVer', 1)
	WITH ([Usuario] varchar(50), NumeroCuenta int) AS D
	INNER JOIN [dbo].[Usuarios] AS U
	ON D.Usuario = U.Username
	INNER JOIN [dbo].[CuentaAhorros] AS CA
	ON CA.NumeroCuenta = D.NumeroCuenta

	EXEC sp_xml_removedocument @hdoc
END
GO
