USE [03_TimeKeeper_숭의여대]
GO
/****** Object:  StoredProcedure [dbo].[sp_empty_insert]    Script Date: 2021-02-02 오후 4:05:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		brad cho
-- Create date: 2018.10.08
-- Description:	
/*
EXEC sp_user_screenlock_password_approve_time_insert 1, '2018-10-08 11:00', '2018-10-08 15:00', 'test'
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_user_screenlock_password_approve_time_insert]		
	@user_no		INT,	
	@company_no		INT,
	@screenlock_password_approve_time		DATETIME
AS
BEGIN	
	
	-- 당일 정보가 없는 경우 정보 insert
	IF NOT EXISTS(
		SELECT *
		FROM [dbo].[tb_work_time_user] WITH(NOLOCK)
		WHERE user_no = @user_no
		AND work_date = CONVERT(DATE, GETDATE())
	)
	BEGIN
		EXEC [dbo].[sp_work_time_user_init] @user_no
	END


	UPDATE [dbo].[tb_work_time_user] WITH(ROWLOCK)
	SET office_in_time = CASE WHEN @screenlock_password_approve_time IS NULL THEN office_in_time ELSE @screenlock_password_approve_time END
	WHERE user_no = @user_no
	AND work_date = CONVERT(DATE, GETDATE())

END








