USE [master]
GO
/****** Object:  Database [%database_name%]    Script Date: 04/19/2022 15:05:28 ******/
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'%database_name%')
BEGIN
CREATE DATABASE [%database_name%] ON  PRIMARY 
( NAME = N'%database_name%_Data', FILENAME = N'%path%\%database_name%.mdf' , SIZE = %size%MB, MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'%database_name%_Log', FILENAME = N'%path%\%database_name%.ldf' , SIZE = %size%MB, MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 COLLATE Traditional_Spanish_CI_AS
END
GO
ALTER DATABASE [%database_name%] SET COMPATIBILITY_LEVEL = 80
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [%database_name%].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [%database_name%] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [%database_name%] SET ANSI_NULLS OFF
GO
ALTER DATABASE [%database_name%] SET ANSI_PADDING OFF
GO
ALTER DATABASE [%database_name%] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [%database_name%] SET ARITHABORT OFF
GO
ALTER DATABASE [%database_name%] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [%database_name%] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [%database_name%] SET AUTO_SHRINK ON
GO
ALTER DATABASE [%database_name%] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [%database_name%] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [%database_name%] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [%database_name%] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [%database_name%] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [%database_name%] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [%database_name%] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [%database_name%] SET  DISABLE_BROKER
GO
ALTER DATABASE [%database_name%] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [%database_name%] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [%database_name%] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [%database_name%] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [%database_name%] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [%database_name%] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [%database_name%] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [%database_name%] SET  READ_WRITE
GO
ALTER DATABASE [%database_name%] SET RECOVERY SIMPLE
GO
ALTER DATABASE [%database_name%] SET  MULTI_USER
GO
ALTER DATABASE [%database_name%] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [%database_name%] SET DB_CHAINING OFF
GO

USE [%database_name%];
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[country]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[country](
	[id] [uniqueidentifier] NOT NULL,
	[code] [varchar](500) COLLATE Traditional_Spanish_CI_AS NOT NULL,
	[name] [varchar](500) COLLATE Traditional_Spanish_CI_AS NOT NULL,
	[name_spanish] [varchar](500) COLLATE Traditional_Spanish_CI_AS NULL,
 CONSTRAINT [PK__lncountr__3213E83F3CF40B7E] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[timezone]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[timezone](
	[id] [uniqueidentifier] NOT NULL,
	[offset] [float] NOT NULL,
	[large_description] [varchar](500) COLLATE Traditional_Spanish_CI_AS NULL,
	[short_description] [varchar](500) COLLATE Traditional_Spanish_CI_AS NULL,
 CONSTRAINT [PK__timezone__3213E83F1FEBB863] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[account]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[account](
	[id] [uniqueidentifier] NOT NULL,
	[id_account_owner] [uniqueidentifier] NOT NULL,
	[name] [varchar](500) COLLATE Traditional_Spanish_CI_AS NOT NULL,
	[create_time] [datetime] NOT NULL,
	[delete_time] [datetime] NULL,
	[id_timezone] [uniqueidentifier] NOT NULL,
	[domain_for_ssm] [varchar](500) COLLATE Traditional_Spanish_CI_AS NULL,
	[from_email_for_ssm] [varchar](500) COLLATE Traditional_Spanish_CI_AS NULL,
	[from_name_for_ssm] [varchar](500) COLLATE Traditional_Spanish_CI_AS NULL,
	[domain_for_ssm_verified] [bit] NULL,
	[id_user_to_contact] [uniqueidentifier] NOT NULL, -- this is the user owner of the account
	[api_key] [varchar](500) COLLATE Traditional_Spanish_CI_AS NULL,
 CONSTRAINT [PK_account] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[user](
	[id] [uniqueidentifier] NOT NULL,
	[id_account] [uniqueidentifier] NOT NULL REFERENCES [account]([id]),
	[create_time] [datetime] NOT NULL,
	[delete_time] [datetime] NULL,
	[email] [varchar](500) COLLATE Traditional_Spanish_CI_AS NOT NULL,
	[password] [varchar](5000) COLLATE Traditional_Spanish_CI_AS NOT NULL,
	[name] [varchar](500) COLLATE Traditional_Spanish_CI_AS NOT NULL,
	[phone] [varchar](500) COLLATE Traditional_Spanish_CI_AS NULL,
	[verified] [bit] NULL,
 CONSTRAINT [PK_user] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_user__email] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__account__id_account_owner]') AND parent_object_id = OBJECT_ID(N'[dbo].[account]'))
ALTER TABLE [dbo].[account]  WITH CHECK ADD  CONSTRAINT [FK__account__id_account_owner] FOREIGN KEY([id_account_owner])
REFERENCES [dbo].[account] ([ID])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__account__id_timezone]') AND parent_object_id = OBJECT_ID(N'[dbo].[timezone]'))
ALTER TABLE [dbo].[account]  WITH CHECK ADD  CONSTRAINT [FK__account__id_timezone] FOREIGN KEY([id_shard])
REFERENCES [dbo].[shard] ([ID])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__account__id_user_to_contact]') AND parent_object_id = OBJECT_ID(N'[dbo].[account]'))
ALTER TABLE [dbo].[account]  WITH CHECK ADD  CONSTRAINT [FK__account__id_user_to_contact] FOREIGN KEY([id_user_to_contact])
REFERENCES [dbo].[user] ([ID])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__user__id_account]') AND parent_object_id = OBJECT_ID(N'[dbo].[user]'))
ALTER TABLE [dbo].[user]  WITH CHECK ADD  CONSTRAINT [FK__user__id_account] FOREIGN KEY([id_user])
REFERENCES [dbo].[account] ([ID])
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user_config]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[user_config](
	[id] [uniqueidentifier] NOT NULL,
	[id_user] [uniqueidentifier] NOT NULL,
	[create_time] [datetime] NOT NULL,
	[name] [varchar](500) COLLATE Traditional_Spanish_CI_AS NOT NULL,
	[type] [int] NOT NULL,
	[value_string] [varchar](500) COLLATE Traditional_Spanish_CI_AS NULL,
	[value_int] [int] NULL,
	[value_float] [float] NULL,
	[value_bool] [bit] NULL,
 CONSTRAINT [PK__user_con__3213E83F279EAAAC] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UK_user_config__id__name] UNIQUE NONCLUSTERED 
(
	[id] ASC,
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__user_config__id_user]') AND parent_object_id = OBJECT_ID(N'[dbo].[user_config]'))
ALTER TABLE [dbo].[user]  WITH CHECK ADD  CONSTRAINT [FK__user_config__id_user] FOREIGN KEY([id_user])
REFERENCES [dbo].[user] ([ID])
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user_config_history]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[user_config_history](
	[id] [uniqueidentifier] NOT NULL,
	[id_user] [uniqueidentifier] NOT NULL,
	[create_time] [datetime] NOT NULL,
	[name] [varchar](500) COLLATE Traditional_Spanish_CI_AS NOT NULL,
	[value_string] [varchar](500) COLLATE Traditional_Spanish_CI_AS NULL,
	[value_int] [int] NULL,
	[value_float] [float] NULL,
	[value_bool] [bit] NULL,
	[type] [int] NULL,
 CONSTRAINT [PK__user_con__3213E83F2D578402] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__user_config_history__id_user]') AND parent_object_id = OBJECT_ID(N'[dbo].[user_config_history]'))
ALTER TABLE [dbo].[user_config_history]  WITH CHECK ADD CONSTRAINT [FK__user_config__id_user] FOREIGN KEY([id_user])
REFERENCES [dbo].[user] ([ID])
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[notification]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[notification](
	[id] [uniqueidentifier] NOT NULL,
	[create_time] [datetime] NOT NULL,
	[delivery_time] [datetime] NULL,
	[type] [numeric](18, 0) NOT NULL,
	[id_user] [uniqueidentifier] NULL,
	[name_to] [varchar](500) COLLATE Traditional_Spanish_CI_AS NOT NULL,
	[email_to] [varchar](500) COLLATE Traditional_Spanish_CI_AS NOT NULL,
	[name_from] [varchar](500) COLLATE Traditional_Spanish_CI_AS NOT NULL,
	[email_from] [varchar](500) COLLATE Traditional_Spanish_CI_AS NOT NULL,
	[subject] [varchar](500) COLLATE Traditional_Spanish_CI_AS NOT NULL,
	[body] [text] COLLATE Traditional_Spanish_CI_AS NOT NULL,
	[id_host] [uniqueidentifier] NULL,
 CONSTRAINT [PK__notifica__3213E83F0D99FE17] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__notification__id_user]') AND parent_object_id = OBJECT_ID(N'[dbo].[notification]'))
ALTER TABLE [dbo].[notification]  WITH CHECK ADD  CONSTRAINT [FK__notification__id_user] FOREIGN KEY([id_user])
REFERENCES [dbo].[user] ([ID])
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[timeoffset]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[timeoffset](
	[id] [uniqueidentifier] NOT NULL,
	[region] [varchar](500) COLLATE Traditional_Spanish_CI_AS NOT NULL,
	[utc] [numeric](2, 0) NOT NULL,
	[dst] [numeric](2, 0) NULL,
 CONSTRAINT [PK__timeoffs__3213E83F3E3F6D37] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[zipcode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[zipcode](
	[value] [varchar](500) COLLATE Traditional_Spanish_CI_AS NOT NULL,
 CONSTRAINT [UQ__zipcode__40BBEA3A216325D7] UNIQUE NONCLUSTERED 
(
	[value] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[role]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[role](
	[id] [uniqueidentifier] NOT NULL,
	[name] [varchar](500) COLLATE Traditional_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK__role__3213E83F4668671F] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UK_role__name] UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user_role]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[user_role](
	[id] [uniqueidentifier] NOT NULL,
	[id_user] [uniqueidentifier] NOT NULL,
	[id_role] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK__user_rol__3213E83F4A38F803] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UK_user_role__id_user__id_role] UNIQUE NONCLUSTERED 
(
	[id_user] ASC,
	[id_role] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__user_role__id_user]') AND parent_object_id = OBJECT_ID(N'[dbo].[user_role]'))
ALTER TABLE [dbo].[user_role]  WITH CHECK ADD  CONSTRAINT [FK__user_role__id_user] FOREIGN KEY([id_user])
REFERENCES [dbo].[user] ([ID])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__user_role__id_role]') AND parent_object_id = OBJECT_ID(N'[dbo].[user_role]'))
ALTER TABLE [dbo].[user_role]  WITH CHECK ADD  CONSTRAINT [FK__user_role__id_role] FOREIGN KEY([id_role])
REFERENCES [dbo].[role] ([ID])
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[params]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[params](
	[id] [uniqueidentifier] NOT NULL,
	[name] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[type] [int] NOT NULL,
	[description] [text] COLLATE Traditional_Spanish_CI_AS NULL,
	[value_varchar] [varchar](500) COLLATE Traditional_Spanish_CI_AS NULL,
	[value_numeric] [numeric](18, 0) NULL,
	[value_datetime] [datetime] NULL,
	[value_bit] [bit] NULL,
 CONSTRAINT [PK__params__3213E83F37FA4C37] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UK_params__name] UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO