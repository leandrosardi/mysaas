IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[preference_history]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[preference_history](
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

/*
 * hostory tables should not have foreing keys, because they are huge tables and inserts must be done fast
 *
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__preference_history__id_user]') AND parent_object_id = OBJECT_ID(N'[dbo].[preference_history]'))
ALTER TABLE [dbo].[preference_history]  WITH CHECK ADD CONSTRAINT [FK__preference__id_user] FOREIGN KEY([id_user])
REFERENCES [dbo].[user] ([ID])
GO
*/
