USE [Banco]
GO

/****** Object:  Table [dbo].[Eventos]    Script Date: 20/1/2021 19:46:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Eventos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoEvento] [int] NOT NULL,
	[IdUser] [int] NOT NULL,
	[IP] [varchar](50) NOT NULL,
	[Fecha] [date] NOT NULL,
	[XMLAntes] [varchar](256) NOT NULL,
	[XMLDespues] [varchar](256) NOT NULL,
 CONSTRAINT [PK_Eventos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Eventos]  WITH CHECK ADD  CONSTRAINT [FK_Eventos_TipoEvento] FOREIGN KEY([IdTipoEvento])
REFERENCES [dbo].[TipoEvento] ([Id])
GO

ALTER TABLE [dbo].[Eventos] CHECK CONSTRAINT [FK_Eventos_TipoEvento]
GO

ALTER TABLE [dbo].[Eventos]  WITH CHECK ADD  CONSTRAINT [FK_Eventos_Usuarios] FOREIGN KEY([IdUser])
REFERENCES [dbo].[Usuarios] ([Id])
GO

ALTER TABLE [dbo].[Eventos] CHECK CONSTRAINT [FK_Eventos_Usuarios]
GO


