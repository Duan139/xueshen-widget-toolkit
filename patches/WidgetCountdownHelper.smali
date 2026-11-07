.class public final Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;
.super Ljava/lang/Object;
.source "WidgetCountdownHelper.java"


# direct methods
.method public static bindCountdown(Landroid/widget/RemoteViews;Ljava/util/List;)V
    .locals 12

    if-eqz p1, :cond_6

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v0

    if-lez v0, :cond_6

    const/4 v0, 0x0

    invoke-interface {p1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-static {v1, v2, v3}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->isCurrentLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;J)Z

    move-result v4

    if-eqz v4, :cond_0

    invoke-static {v1}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->endMillisForLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)J

    move-result-wide v5

    const-string/jumbo v7, "\u8ddd\u4e0b\u8bfe %s"

    goto :goto_1

    :cond_0
    invoke-static {v1}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->startMillisForLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)J

    move-result-wide v5

    const-wide/16 v8, -0x1

    cmp-long v10, v5, v8

    if-eqz v10, :cond_3

    cmp-long v10, v5, v2

    if-lez v10, :cond_2

    sub-long v8, v5, v2

    const-wide/32 v10, 0x927c0

    cmp-long v0, v8, v10

    if-lez v0, :cond_1

    const-string/jumbo v7, "\u8ddd\u4e0a\u8bfe %s"

    goto :goto_1

    :cond_1
    const-string/jumbo v7, "10\u5206\u949f\u5185\u5f00\u8bfe %s"

    goto :goto_1

    :cond_2
    const-string/jumbo v7, "\u672c\u65f6\u6bb5\u7ed3\u675f\u65f6\u523b\u5f85\u786e\u8ba4"

    move v6, v4

    sget v0, Lcom/szpu/nativeapp/R$id;->course_period_1:I

    invoke-virtual {p0, v0, v7}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    goto :goto_2

    :cond_3
    invoke-static {v1}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->isUnsupportedEveningRange(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)Z

    move-result v0

    if-eqz v0, :cond_4

    const-string/jumbo v7, "\u665a\u95f4\u5355\u8282\u8fb9\u754c\u672a\u786e\u8ba4\uff0c\u4e0d\u63d0\u9192"

    goto :goto_0

    :cond_4
    const-string/jumbo v7, "\u4e0a\u8bfe\u65f6\u523b\u5f85\u786e\u8ba4"

    :goto_0
    move v6, v4

    sget v0, Lcom/szpu/nativeapp/R$id;->course_period_1:I

    invoke-virtual {p0, v0, v7}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    goto :goto_2

    :goto_1
    sub-long v8, v5, v2

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v10

    add-long/2addr v10, v8

    move v6, v4

    move-object v0, p0

    sget v1, Lcom/szpu/nativeapp/R$id;->course_period_1:I

    move-wide v2, v10

    move-object v4, v7

    const/4 v5, 0x1

    invoke-virtual/range {v0 .. v5}, Landroid/widget/RemoteViews;->setChronometer(IJLjava/lang/String;Z)V

    invoke-virtual {p0, v1, v5}, Landroid/widget/RemoteViews;->setChronometerCountDown(IZ)V

    sget v0, Lcom/szpu/nativeapp/R$id;->today_date:I

    const/16 v1, 0x8

    invoke-virtual {p0, v0, v1}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    sget v0, Lcom/szpu/nativeapp/R$id;->term_text:I

    invoke-virtual {p0, v0, v1}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    sget v0, Lcom/szpu/nativeapp/R$id;->footer_text:I

    invoke-virtual {p0, v0, v1}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    :goto_2
    :cond_6
    return-void
.end method

.method private static cancelAllAlarms(Landroid/content/Context;)V
    .locals 0

    invoke-static {p0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->cancelRefreshAlarm(Landroid/content/Context;)V

    invoke-static {p0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->cancelReminderAlarm(Landroid/content/Context;)V

    return-void
.end method

.method private static cancelRefreshAlarm(Landroid/content/Context;)V
    .locals 5

    const-string v0, "alarm"

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/AlarmManager;

    new-instance v1, Landroid/content/Intent;

    const-class v2, Lcom/szpu/nativeapp/widget/CourseReminderReceiver;

    invoke-direct {v1, p0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v2, "com.cloudslow.szpu.ACTION_WIDGET_REFRESH"

    invoke-virtual {v1, v2}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    const/4 v2, 0x1

    const/high16 v3, 0x24000000

    invoke-static {p0, v2, v1, v3}, Landroid/app/PendingIntent;->getBroadcast(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v4

    if-eqz v4, :cond_1

    if-eqz v0, :cond_0

    invoke-virtual {v0, v4}, Landroid/app/AlarmManager;->cancel(Landroid/app/PendingIntent;)V

    :cond_0
    invoke-virtual {v4}, Landroid/app/PendingIntent;->cancel()V

    :cond_1
    return-void
.end method

.method private static cancelReminderAlarm(Landroid/content/Context;)V
    .locals 5

    const-string v0, "alarm"

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/AlarmManager;

    new-instance v1, Landroid/content/Intent;

    const-class v2, Lcom/szpu/nativeapp/widget/CourseReminderReceiver;

    invoke-direct {v1, p0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v2, "com.cloudslow.szpu.ACTION_COURSE_REMINDER"

    invoke-virtual {v1, v2}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    const/4 v2, 0x2

    const/high16 v3, 0x24000000

    invoke-static {p0, v2, v1, v3}, Landroid/app/PendingIntent;->getBroadcast(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v4

    if-eqz v4, :cond_1

    if-eqz v0, :cond_0

    invoke-virtual {v0, v4}, Landroid/app/AlarmManager;->cancel(Landroid/app/PendingIntent;)V

    :cond_0
    invoke-virtual {v4}, Landroid/app/PendingIntent;->cancel()V

    :cond_1
    return-void
.end method

.method private static endMillisForLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)J
    .locals 2

    if-eqz p0, :cond_0

    invoke-static {p0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->isSupportedTimedRange(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)Z

    move-result v1

    if-eqz v1, :cond_0

    iget v0, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->endPeriod:I

    invoke-static {v0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->endTimeForPeriod(I)Ljava/time/LocalTime;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-static {v0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->epochMillisForTime(Ljava/time/LocalTime;)J

    move-result-wide v0

    return-wide v0

    :cond_0
    const-wide/16 v0, -0x1

    return-wide v0
.end method

.method private static endTimeForPeriod(I)Ljava/time/LocalTime;
    .locals 2

    invoke-static {p0}, Lcom/szpu/nativeapp/model/TimetablePeriodRulerSchedule;->rowFor(I)Lcom/szpu/nativeapp/model/TimetablePeriodRulerSchedule$Row;

    move-result-object v0

    if-eqz v0, :cond_0

    iget-object v1, v0, Lcom/szpu/nativeapp/model/TimetablePeriodRulerSchedule$Row;->endTime:Ljava/lang/String;

    invoke-static {v1}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->parseClock(Ljava/lang/String;)Ljava/time/LocalTime;

    move-result-object v0

    return-object v0

    :cond_0
    const/4 v0, 0x0

    return-object v0
.end method

.method private static epochMillisForTime(Ljava/time/LocalTime;)J
    .locals 4

    invoke-static {}, Ljava/util/Calendar;->getInstance()Ljava/util/Calendar;

    move-result-object v0

    invoke-virtual {p0}, Ljava/time/LocalTime;->getHour()I

    move-result v1

    const/16 v2, 0xb

    invoke-virtual {v0, v2, v1}, Ljava/util/Calendar;->set(II)V

    invoke-virtual {p0}, Ljava/time/LocalTime;->getMinute()I

    move-result v1

    const/16 v2, 0xc

    invoke-virtual {v0, v2, v1}, Ljava/util/Calendar;->set(II)V

    const/4 v1, 0x0

    const/16 v2, 0xd

    invoke-virtual {v0, v2, v1}, Ljava/util/Calendar;->set(II)V

    const/16 v2, 0xe

    invoke-virtual {v0, v2, v1}, Ljava/util/Calendar;->set(II)V

    invoke-virtual {v0}, Ljava/util/Calendar;->getTimeInMillis()J

    move-result-wide v0

    return-wide v0
.end method

.method private static findCurrentLine(Ljava/util/List;J)Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;
    .locals 3

    if-eqz p0, :cond_1

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;

    invoke-static {v1, p1, p2}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->isCurrentLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;J)Z

    move-result v2

    if-eqz v2, :cond_0

    return-object v1

    :cond_1
    const/4 v0, 0x0

    return-object v0
.end method

.method private static findNextTimedLine(Ljava/util/List;J)Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;
    .locals 8

    if-eqz p0, :cond_1

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;

    invoke-static {v1}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->startMillisForLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)J

    move-result-wide v2

    const-wide/16 v4, -0x1

    cmp-long v6, v2, v4

    if-eqz v6, :cond_0

    cmp-long v6, v2, p1

    if-lez v6, :cond_0

    return-object v1

    :cond_1
    const/4 v0, 0x0

    return-object v0
.end method

.method private static hasAnyWidget(Landroid/content/Context;)Z
    .locals 4

    invoke-static {p0}, Landroid/appwidget/AppWidgetManager;->getInstance(Landroid/content/Context;)Landroid/appwidget/AppWidgetManager;

    move-result-object v0

    new-instance v1, Landroid/content/ComponentName;

    const-class v2, Lcom/szpu/nativeapp/widget/TimetableWidgetTodayProvider;

    invoke-direct {v1, p0, v2}, Landroid/content/ComponentName;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {v0, v1}, Landroid/appwidget/AppWidgetManager;->getAppWidgetIds(Landroid/content/ComponentName;)[I

    move-result-object v1

    array-length v1, v1

    if-lez v1, :cond_0

    const/4 v0, 0x1

    return v0

    :cond_0
    new-instance v1, Landroid/content/ComponentName;

    const-class v2, Lcom/szpu/nativeapp/widget/TimetableWidgetProvider;

    invoke-direct {v1, p0, v2}, Landroid/content/ComponentName;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {v0, v1}, Landroid/appwidget/AppWidgetManager;->getAppWidgetIds(Landroid/content/ComponentName;)[I

    move-result-object v1

    array-length v1, v1

    if-lez v1, :cond_1

    const/4 v0, 0x1

    return v0

    :cond_1
    new-instance v1, Landroid/content/ComponentName;

    const-class v2, Lcom/szpu/nativeapp/widget/TimetableWidgetWeekProvider;

    invoke-direct {v1, p0, v2}, Landroid/content/ComponentName;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {v0, v1}, Landroid/appwidget/AppWidgetManager;->getAppWidgetIds(Landroid/content/ComponentName;)[I

    move-result-object v1

    array-length v1, v1

    if-lez v1, :cond_2

    const/4 v0, 0x1

    return v0

    :cond_2
    const/4 v0, 0x0

    return v0
.end method

.method public static isAppNotificationEnabled(Landroid/content/Context;)Z
    .locals 4

    const-string v0, "notification"

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/NotificationManager;

    if-eqz v0, :cond_0

    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x18

    if-lt v1, v2, :cond_1

    invoke-virtual {v0}, Landroid/app/NotificationManager;->areNotificationsEnabled()Z

    move-result v1

    if-eqz v1, :cond_0

    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x1a

    if-lt v1, v2, :cond_1

    const-string v2, "course_reminders"

    invoke-virtual {v0, v2}, Landroid/app/NotificationManager;->getNotificationChannel(Ljava/lang/String;)Landroid/app/NotificationChannel;

    move-result-object v2

    if-eqz v2, :cond_1

    invoke-virtual {v2}, Landroid/app/NotificationChannel;->getImportance()I

    move-result v2

    if-nez v2, :cond_1

    :cond_0
    const/4 v0, 0x0

    return v0

    :cond_1
    const/4 v0, 0x1

    return v0
.end method

.method private static isCurrentLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;J)Z
    .locals 8

    invoke-static {p0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->startMillisForLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)J

    move-result-wide v0

    const-wide/16 v2, -0x1

    cmp-long v4, v0, v2

    if-eqz v4, :cond_1

    invoke-static {p0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->endMillisForLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)J

    move-result-wide v2

    const-wide/16 v4, -0x1

    cmp-long v6, v2, v4

    if-eqz v6, :cond_1

    cmp-long v6, v0, p1

    if-lez v6, :cond_0

    goto :goto_0

    :cond_0
    cmp-long v6, p1, v2

    if-ltz v6, :cond_2

    :cond_1
    :goto_0
    const/4 v0, 0x0

    return v0

    :cond_2
    const/4 v0, 0x1

    return v0
.end method

.method public static isReminderHandled(Landroid/content/Context;J)Z
    .locals 6

    if-eqz p0, :cond_0

    const-string v0, "course_reminder_state"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "handled_course_start_millis"

    const-wide/16 v2, 0x0

    invoke-interface {v0, v1, v2, v3}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v2

    cmp-long v0, v2, p1

    if-nez v0, :cond_0

    const/4 v0, 0x1

    return v0

    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method private static isSupportedTimedRange(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)Z
    .locals 4

    if-eqz p0, :cond_2

    iget v0, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->startPeriod:I

    iget v1, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->endPeriod:I

    const/16 v2, 0x8

    if-gt v0, v2, :cond_0

    if-gt v1, v2, :cond_2

    const/4 v0, 0x1

    return v0

    :cond_0
    const/16 v2, 0x9

    if-ne v0, v2, :cond_1

    const/16 v2, 0xa

    if-ne v1, v2, :cond_2

    const/4 v0, 0x1

    return v0

    :cond_1
    const/16 v2, 0xb

    if-ne v0, v2, :cond_2

    const/16 v2, 0xc

    if-ne v1, v2, :cond_2

    const/4 v0, 0x1

    return v0

    :cond_2
    const/4 v0, 0x0

    return v0
.end method

.method private static isUnknownEveningRelevant(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;J)Z
    .locals 8

    invoke-static {p0, p1, p2}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->isUnknownEveningRelevantStrict(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;J)Z

    move-result v0

    return v0

    if-eqz p0, :cond_2

    iget v0, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->startPeriod:I

    iget v1, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->endPeriod:I

    const/16 v2, 0x9

    if-lt v0, v2, :cond_1

    const/16 v2, 0xa

    if-le v0, v2, :cond_0

    goto :goto_0

    :cond_0
    const/16 v2, 0xa

    if-gt v1, v2, :cond_1

    const/16 v3, 0xa

    invoke-static {v3}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->endTimeForPeriod(I)Ljava/time/LocalTime;

    move-result-object v3

    if-eqz v3, :cond_2

    invoke-static {v3}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->epochMillisForTime(Ljava/time/LocalTime;)J

    move-result-wide v4

    cmp-long v6, p1, v4

    if-ltz v6, :cond_3

    goto :goto_1

    :cond_1
    :goto_0
    const/16 v2, 0xb

    if-lt v0, v2, :cond_2

    const/16 v2, 0xc

    if-gt v0, v2, :cond_2

    if-gt v1, v2, :cond_2

    const/16 v3, 0xc

    invoke-static {v3}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->endTimeForPeriod(I)Ljava/time/LocalTime;

    move-result-object v3

    if-eqz v3, :cond_2

    invoke-static {v3}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->epochMillisForTime(Ljava/time/LocalTime;)J

    move-result-wide v4

    cmp-long v6, p1, v4

    if-ltz v6, :cond_3

    :cond_2
    :goto_1
    const/4 v0, 0x0

    return v0

    :cond_3
    const/4 v0, 0x1

    return v0
.end method

.method private static isUnknownEveningRelevantStrict(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;J)Z
    .locals 7

    if-eqz p0, :cond_1

    invoke-static {p0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->isUnsupportedEveningRange(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)Z

    move-result v0

    if-eqz v0, :cond_1

    iget v1, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->startPeriod:I

    iget v2, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->endPeriod:I

    const/16 v3, 0xa

    if-gt v1, v3, :cond_0

    const/16 v3, 0x9

    if-lt v2, v3, :cond_0

    move-wide v3, p1

    const/16 v5, 0x9

    const/16 v6, 0xa

    invoke-static/range {v3 .. v6}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->isWithinEveningBlock(JII)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    return v0

    :cond_0
    const/16 v3, 0xc

    if-gt v1, v3, :cond_1

    const/16 v3, 0xb

    if-lt v2, v3, :cond_1

    move-wide v3, p1

    const/16 v5, 0xb

    const/16 v6, 0xc

    invoke-static/range {v3 .. v6}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->isWithinEveningBlock(JII)Z

    move-result v0

    if-eqz v0, :cond_1

    const/4 v0, 0x1

    return v0

    :cond_1
    const/4 v0, 0x0

    return v0
.end method

.method private static isUnsupportedEveningRange(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)Z
    .locals 4

    if-eqz p0, :cond_1

    iget v0, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->startPeriod:I

    iget v1, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->endPeriod:I

    const/16 v2, 0xa

    if-gt v0, v2, :cond_0

    const/16 v2, 0x9

    if-lt v1, v2, :cond_0

    const/16 v2, 0x9

    if-ne v0, v2, :cond_2

    const/16 v2, 0xa

    if-ne v1, v2, :cond_2

    goto :goto_0

    :cond_0
    const/16 v2, 0xc

    if-gt v0, v2, :cond_1

    const/16 v2, 0xb

    if-lt v1, v2, :cond_1

    const/16 v2, 0xb

    if-ne v0, v2, :cond_2

    const/16 v2, 0xc

    if-ne v1, v2, :cond_2

    :cond_1
    :goto_0
    const/4 v0, 0x0

    return v0

    :cond_2
    const/4 v0, 0x1

    return v0
.end method

.method private static isWithinEveningBlock(JII)Z
    .locals 8

    invoke-static {p2}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->startTimeForPeriod(I)Ljava/time/LocalTime;

    move-result-object v0

    invoke-static {p3}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->endTimeForPeriod(I)Ljava/time/LocalTime;

    move-result-object v1

    if-eqz v0, :cond_0

    if-eqz v1, :cond_0

    invoke-static {v0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->epochMillisForTime(Ljava/time/LocalTime;)J

    move-result-wide v2

    invoke-static {v1}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->epochMillisForTime(Ljava/time/LocalTime;)J

    move-result-wide v4

    const-wide/32 v6, 0x927c0

    sub-long/2addr v2, v6

    cmp-long v6, p0, v2

    if-ltz v6, :cond_0

    cmp-long v6, p0, v4

    if-ltz v6, :cond_1

    :cond_0
    const/4 v0, 0x0

    return v0

    :cond_1
    const/4 v0, 0x1

    return v0
.end method

.method public static markReminderHandled(Landroid/content/Context;J)V
    .locals 8

    if-eqz p0, :cond_0

    const-string v0, "course_reminder_state"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    const-string v3, "handled_course_start_millis"

    invoke-interface {v2, v3, p1, p2}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    :cond_0
    return-void
.end method

.method private static markReminderSettingsPromptShown(Landroid/content/Context;Ljava/lang/String;)V
    .locals 6

    if-eqz p0, :cond_0

    const-string v0, "course_reminder_state"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    invoke-interface {v0, p1, v1, v2}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    :cond_0
    return-void
.end method

.method public static maybePromptReminderSettings(Landroid/app/Activity;)Z
    .locals 12

    if-eqz p0, :cond_4

    invoke-virtual {p0}, Landroid/app/Activity;->isFinishing()Z

    move-result v0

    if-eqz v0, :cond_0

    goto/16 :goto_0

    :cond_0
    invoke-virtual {p0}, Landroid/app/Activity;->isDestroyed()Z

    move-result v0

    if-eqz v0, :cond_1

    goto/16 :goto_0

    :cond_1
    :try_start_0
    invoke-static {p0}, Lcom/szpu/nativeapp/widget/CourseReminderReceiver;->ensureChannel(Landroid/content/Context;)V

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x21

    if-lt v0, v1, :cond_2

    const-string v0, "android.permission.POST_NOTIFICATIONS"

    invoke-virtual {p0, v0}, Landroid/app/Activity;->checkSelfPermission(Ljava/lang/String;)I

    move-result v1

    if-eqz v1, :cond_2

    const-string v2, "course_reminder_state"

    const/4 v3, 0x0

    invoke-virtual {p0, v2, v3}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    const-string v3, "notification_permission_requested"

    const/4 v4, 0x0

    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v4

    if-nez v4, :cond_3

    invoke-static {p0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->requestNotificationPermission(Landroid/app/Activity;)V

    const/4 v0, 0x1

    return v0

    :cond_2
    invoke-static {p0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->isAppNotificationEnabled(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_3

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1f

    if-lt v0, v1, :cond_4

    const-string v0, "alarm"

    invoke-virtual {p0, v0}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/AlarmManager;

    if-eqz v0, :cond_4

    invoke-virtual {v0}, Landroid/app/AlarmManager;->canScheduleExactAlarms()Z

    move-result v1

    if-nez v1, :cond_4

    const-string v0, "exact_alarm_prompt_at"

    invoke-static {p0, v0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->shouldShowReminderSettingsPrompt(Landroid/content/Context;Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_4

    invoke-static {p0, v0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->markReminderSettingsPromptShown(Landroid/content/Context;Ljava/lang/String;)V

    new-instance v0, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    invoke-direct {v0, p0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;-><init>(Landroid/content/Context;)V

    const-string/jumbo v1, "\u7cbe\u786e\u95f9\u949f\u672a\u5f00\u653e"

    invoke-virtual {v0, v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setTitle(Ljava/lang/CharSequence;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    const-string/jumbo v1, "\u672a\u5141\u8bb8\u7cbe\u786e\u95f9\u949f\u65f6\uff0c\u7cfb\u7edf\u53ef\u80fd\u5ef6\u8fdf\u8bfe\u524d\u63d0\u9192\u3002\u53ef\u524d\u5f80\u7cbe\u786e\u95f9\u949f\u8bbe\u7f6e\u5c1d\u8bd5\u5f00\u542f\u3002"

    invoke-virtual {v0, v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setMessage(Ljava/lang/CharSequence;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    new-instance v1, Lcom/szpu/nativeapp/widget/CourseReminderSettingsClickListener;

    const/4 v2, 0x1

    invoke-direct {v1, p0, v2}, Lcom/szpu/nativeapp/widget/CourseReminderSettingsClickListener;-><init>(Landroid/app/Activity;I)V

    const-string/jumbo v2, "\u53bb\u7cbe\u786e\u95f9\u949f\u8bbe\u7f6e"

    invoke-virtual {v0, v2, v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    const-string/jumbo v2, "\u7a0d\u540e"

    const/4 v3, 0x0

    invoke-virtual {v0, v2, v3}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    invoke-virtual {v0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->show()Landroidx/appcompat/app/AlertDialog;

    const/4 v0, 0x1

    return v0

    :cond_3
    const-string v0, "notification_settings_prompt_at"

    invoke-static {p0, v0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->shouldShowReminderSettingsPrompt(Landroid/content/Context;Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_4

    invoke-static {p0, v0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->markReminderSettingsPromptShown(Landroid/content/Context;Ljava/lang/String;)V

    new-instance v0, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    invoke-direct {v0, p0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;-><init>(Landroid/content/Context;)V

    const-string/jumbo v1, "\u8bfe\u7a0b\u63d0\u9192\u672a\u5f00\u542f"

    invoke-virtual {v0, v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setTitle(Ljava/lang/CharSequence;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    const-string/jumbo v1, "\u8bf7\u5f00\u542f\u5e94\u7528\u901a\u77e5\u6743\u9650\uff0c\u5426\u5219\u8bfe\u524d\u63d0\u9192\u4e0d\u4f1a\u663e\u793a\u3002"

    invoke-virtual {v0, v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setMessage(Ljava/lang/CharSequence;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    new-instance v1, Lcom/szpu/nativeapp/widget/CourseReminderSettingsClickListener;

    const/4 v2, 0x0

    invoke-direct {v1, p0, v2}, Lcom/szpu/nativeapp/widget/CourseReminderSettingsClickListener;-><init>(Landroid/app/Activity;I)V

    const-string/jumbo v2, "\u53bb\u901a\u77e5\u8bbe\u7f6e"

    invoke-virtual {v0, v2, v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    const-string/jumbo v2, "\u7a0d\u540e"

    const/4 v3, 0x0

    invoke-virtual {v0, v2, v3}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    invoke-virtual {v0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->show()Landroidx/appcompat/app/AlertDialog;

    const/4 v0, 0x1

    return v0

    :cond_4
    :goto_0
    const/4 v0, 0x0

    return v0
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    move-exception v0

    const-string v1, "CourseReminder"

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/Throwable;)I

    const/4 v0, 0x0

    return v0
.end method

.method private static nextMidnightMillis()J
    .locals 3

    invoke-static {}, Ljava/util/Calendar;->getInstance()Ljava/util/Calendar;

    move-result-object v0

    const/4 v1, 0x0

    const/16 v2, 0xb

    invoke-virtual {v0, v2, v1}, Ljava/util/Calendar;->set(II)V

    const/16 v2, 0xc

    invoke-virtual {v0, v2, v1}, Ljava/util/Calendar;->set(II)V

    const/16 v2, 0xd

    invoke-virtual {v0, v2, v1}, Ljava/util/Calendar;->set(II)V

    const/16 v2, 0xe

    invoke-virtual {v0, v2, v1}, Ljava/util/Calendar;->set(II)V

    const/4 v1, 0x5

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Ljava/util/Calendar;->add(II)V

    invoke-virtual {v0}, Ljava/util/Calendar;->getTimeInMillis()J

    move-result-wide v0

    return-wide v0
.end method

.method private static parseClock(Ljava/lang/String;)Ljava/time/LocalTime;
    .locals 3

    if-eqz p0, :cond_1

    const-string v0, "/"

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    if-ltz v1, :cond_0

    const/4 v0, 0x0

    return-object v0

    :cond_0
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    const-string v0, ":"

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    if-ltz v1, :cond_1

    :try_start_0
    invoke-static {p0}, Ljava/time/LocalTime;->parse(Ljava/lang/CharSequence;)Ljava/time/LocalTime;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    :catch_0
    move-exception v0

    :cond_1
    const/4 v0, 0x0

    return-object v0
.end method

.method public static requestNotificationPermission(Landroid/app/Activity;)V
    .locals 7

    if-eqz p0, :cond_0

    invoke-static {p0}, Lcom/szpu/nativeapp/widget/CourseReminderReceiver;->ensureChannel(Landroid/content/Context;)V

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x21

    if-lt v0, v1, :cond_0

    const-string v0, "android.permission.POST_NOTIFICATIONS"

    invoke-virtual {p0, v0}, Landroid/app/Activity;->checkSelfPermission(Ljava/lang/String;)I

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "course_reminder_state"

    const/4 v2, 0x0

    invoke-virtual {p0, v1, v2}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    const-string v2, "notification_permission_requested"

    const/4 v3, 0x0

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v4

    if-nez v4, :cond_0

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const/4 v3, 0x1

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/String;

    const/4 v2, 0x0

    aput-object v0, v1, v2

    const/16 v0, 0x2a

    invoke-virtual {p0, v1, v0}, Landroid/app/Activity;->requestPermissions([Ljava/lang/String;I)V

    :cond_0
    return-void
.end method

.method public static schedule(Landroid/content/Context;Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;)V
    .locals 14

    if-eqz p1, :cond_3

    const/4 v0, 0x0

    iget-object v0, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->todayLines:Ljava/util/List;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-static {v0, v2, v3}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->findCurrentLine(Ljava/util/List;J)Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;

    move-result-object v4

    invoke-static {v0, v2, v3}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->findNextTimedLine(Ljava/util/List;J)Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;

    move-result-object v5

    if-eqz v4, :cond_0

    invoke-static {v4}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->endMillisForLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)J

    move-result-wide v6

    cmp-long v8, v6, v2

    if-lez v8, :cond_0

    move-wide v10, v6

    goto :goto_0

    :cond_0
    if-eqz v5, :cond_1

    invoke-static {v5}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->startMillisForLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)J

    move-result-wide v6

    cmp-long v8, v6, v2

    if-lez v8, :cond_1

    move-wide v10, v6

    goto :goto_0

    :cond_1
    invoke-static {}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->nextMidnightMillis()J

    move-result-wide v10

    :goto_0
    invoke-static {p0, v10, v11}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->setRefreshAlarm(Landroid/content/Context;J)V

    if-eqz v5, :cond_2

    invoke-static {v5}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->startMillisForLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)J

    move-result-wide v6

    const-wide/16 v12, -0x1

    cmp-long v0, v6, v12

    if-eqz v0, :cond_2

    invoke-static {p0, v6, v7}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->isReminderHandled(Landroid/content/Context;J)Z

    move-result v0

    if-nez v0, :cond_2

    sub-long v8, v6, v2

    const-wide/16 v12, 0x0

    cmp-long v0, v8, v12

    if-lez v0, :cond_2

    const-wide/32 v12, 0x927c0

    cmp-long v0, v8, v12

    if-ltz v0, :cond_2

    sub-long v10, v6, v12

    goto :goto_1

    :goto_1
    invoke-static {p0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->isAppNotificationEnabled(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-static {p0, v5, v10, v11}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->setReminderAlarm(Landroid/content/Context;Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;J)V

    return-void

    :cond_2
    invoke-static {p0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->cancelReminderAlarm(Landroid/content/Context;)V

    return-void

    :cond_3
    invoke-static {p0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->cancelAllAlarms(Landroid/content/Context;)V

    return-void
.end method

.method public static selectUpcomingLines(Ljava/util/List;)Ljava/util/List;
    .locals 12

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    if-eqz p0, :cond_5

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v8

    invoke-static {p0, v8, v9}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->findCurrentLine(Ljava/util/List;J)Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;

    move-result-object v2

    if-eqz v2, :cond_0

    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_0
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_1
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_5

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;

    if-ne v3, v2, :cond_2

    goto :goto_0

    :cond_2
    invoke-static {v3}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->startMillisForLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)J

    move-result-wide v4

    const-wide/16 v10, -0x1

    cmp-long v6, v4, v10

    if-eqz v6, :cond_4

    cmp-long v6, v4, v8

    if-lez v6, :cond_3

    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_1

    :cond_3
    invoke-static {v3}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->endMillisForLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)J

    move-result-wide v4

    cmp-long v6, v4, v10

    if-eqz v6, :cond_4

    goto :goto_0

    :cond_4
    invoke-static {v3, v8, v9}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->isUnknownEveningRelevant(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;J)Z

    move-result v6

    if-eqz v6, :cond_1

    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :goto_1
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v6

    const/4 v7, 0x6

    if-lt v6, v7, :cond_1

    :cond_5
    return-object v0
.end method

.method private static setAlarm(Landroid/content/Context;JLandroid/app/PendingIntent;)V
    .locals 4

    const-string v0, "alarm"

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/AlarmManager;

    if-eqz v0, :cond_1

    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x1f

    if-lt v1, v2, :cond_0

    :try_start_0
    invoke-virtual {v0}, Landroid/app/AlarmManager;->canScheduleExactAlarms()Z
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    move-result v1

    if-eqz v1, :cond_0

    goto :goto_0

    :catch_0
    move-exception v1

    const-string v2, "CourseReminder"

    invoke-static {v2, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_1

    :goto_0
    const/4 v1, 0x0

    :try_start_1
    invoke-virtual {v0, v1, p1, p2, p3}, Landroid/app/AlarmManager;->setExactAndAllowWhileIdle(IJLandroid/app/PendingIntent;)V
    :try_end_1
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_2

    :catch_1
    move-exception v1

    const-string v2, "CourseReminder"

    invoke-static {v2, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_0
    :goto_1
    const/4 v1, 0x0

    :try_start_2
    invoke-virtual {v0, v1, p1, p2, p3}, Landroid/app/AlarmManager;->setAndAllowWhileIdle(IJLandroid/app/PendingIntent;)V
    :try_end_2
    .catch Ljava/lang/RuntimeException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_2

    :catch_2
    move-exception v1

    const-string v2, "CourseReminder"

    invoke-static {v2, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_1
    :goto_2
    return-void
.end method

.method private static setChronometer(Landroid/widget/RemoteViews;IJLjava/lang/String;Z)V
    .locals 0

    invoke-virtual/range {p0 .. p5}, Landroid/widget/RemoteViews;->setChronometer(IJLjava/lang/String;Z)V

    return-void
.end method

.method private static setExactReminderAlarm(Landroid/content/Context;JLandroid/app/PendingIntent;)V
    .locals 3

    const-string v0, "alarm"

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/AlarmManager;

    if-eqz v0, :cond_1

    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x1f

    if-lt v1, v2, :cond_0

    invoke-virtual {v0}, Landroid/app/AlarmManager;->canScheduleExactAlarms()Z

    move-result v1

    if-nez v1, :cond_0

    const/4 v1, 0x0

    :try_start_fallback
    invoke-virtual {v0, v1, p1, p2, p3}, Landroid/app/AlarmManager;->setAndAllowWhileIdle(IJLandroid/app/PendingIntent;)V
    :try_end_fallback
    .catch Ljava/lang/Exception; {:try_start_fallback .. :try_end_fallback} :catch_fallback

    goto :goto_0

    :catch_fallback
    move-exception v1

    invoke-static {p0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->cancelReminderAlarm(Landroid/content/Context;)V

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :try_start_0
    invoke-virtual {v0, v1, p1, p2, p3}, Landroid/app/AlarmManager;->setExactAndAllowWhileIdle(IJLandroid/app/PendingIntent;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v2

    const/4 v1, 0x0

    :try_start_1
    invoke-virtual {v0, v1, p1, p2, p3}, Landroid/app/AlarmManager;->setAndAllowWhileIdle(IJLandroid/app/PendingIntent;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_0

    :catch_1
    move-exception v1

    invoke-static {p0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->cancelReminderAlarm(Landroid/content/Context;)V

    :cond_1
    :goto_0
    return-void
.end method

.method private static setRefreshAlarm(Landroid/content/Context;J)V
    .locals 5

    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/szpu/nativeapp/widget/CourseReminderReceiver;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v1, "com.cloudslow.szpu.ACTION_WIDGET_REFRESH"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    const/4 v1, 0x1

    const/high16 v2, 0xc000000

    invoke-static {p0, v1, v0, v2}, Landroid/app/PendingIntent;->getBroadcast(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v3

    invoke-static {p0, p1, p2, v3}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->setAlarm(Landroid/content/Context;JLandroid/app/PendingIntent;)V

    return-void
.end method

.method private static setReminderAlarm(Landroid/content/Context;Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;J)V
    .locals 8

    invoke-static {p0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->cancelReminderAlarm(Landroid/content/Context;)V

    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/szpu/nativeapp/widget/CourseReminderReceiver;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v1, "com.cloudslow.szpu.ACTION_COURSE_REMINDER"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    iget-object v1, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->title:Ljava/lang/String;

    const-string v2, "course_title"

    invoke-virtual {v0, v2, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    iget-object v1, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->detailText:Ljava/lang/String;

    const-string v2, "course_detail"

    invoke-virtual {v0, v2, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    iget-object v1, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->periodText:Ljava/lang/String;

    const-string v2, "course_period"

    invoke-virtual {v0, v2, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-string v1, "course_start_millis"

    invoke-static {p1}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->startMillisForLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)J

    move-result-wide v2

    invoke-virtual {v0, v1, v2, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;J)Landroid/content/Intent;

    const-string v1, "course_end_millis"

    invoke-static {p1}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->endMillisForLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)J

    move-result-wide v2

    invoke-virtual {v0, v1, v2, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;J)Landroid/content/Intent;

    const-string v1, "reminder_fire_millis"

    invoke-virtual {v0, v1, p2, p3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;J)Landroid/content/Intent;

    const-string v1, "notification_id"

    iget v2, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->startPeriod:I

    add-int/lit16 v2, v2, 0x1388

    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const/4 v1, 0x2

    const/high16 v2, 0xc000000

    invoke-static {p0, v1, v0, v2}, Landroid/app/PendingIntent;->getBroadcast(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v4

    invoke-static {p0, p2, p3, v4}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->setExactReminderAlarm(Landroid/content/Context;JLandroid/app/PendingIntent;)V

    return-void
.end method

.method private static shouldShowReminderSettingsPrompt(Landroid/content/Context;Ljava/lang/String;)Z
    .locals 6

    if-eqz p0, :cond_0

    const-string v0, "course_reminder_state"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const-wide/16 v2, 0x0

    invoke-interface {v0, p1, v2, v3}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v2

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    sub-long/2addr v4, v2

    const-wide/32 v2, 0x5265c00

    cmp-long v0, v4, v2

    if-ltz v0, :cond_0

    const/4 v0, 0x1

    return v0

    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method private static startMillisForLine(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)J
    .locals 2

    if-eqz p0, :cond_0

    invoke-static {p0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->isSupportedTimedRange(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)Z

    move-result v1

    if-eqz v1, :cond_0

    iget v0, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->startPeriod:I

    invoke-static {v0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->startTimeForPeriod(I)Ljava/time/LocalTime;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-static {v0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->epochMillisForTime(Ljava/time/LocalTime;)J

    move-result-wide v0

    return-wide v0

    :cond_0
    const-wide/16 v0, -0x1

    return-wide v0
.end method

.method private static startTimeForPeriod(I)Ljava/time/LocalTime;
    .locals 2

    invoke-static {p0}, Lcom/szpu/nativeapp/model/TimetablePeriodRulerSchedule;->rowFor(I)Lcom/szpu/nativeapp/model/TimetablePeriodRulerSchedule$Row;

    move-result-object v0

    if-eqz v0, :cond_0

    iget-object v1, v0, Lcom/szpu/nativeapp/model/TimetablePeriodRulerSchedule$Row;->startTime:Ljava/lang/String;

    invoke-static {v1}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->parseClock(Ljava/lang/String;)Ljava/time/LocalTime;

    move-result-object v0

    return-object v0

    :cond_0
    const/4 v0, 0x0

    return-object v0
.end method

.method public static stopCountdown(Landroid/widget/RemoteViews;)V
    .locals 6

    move-object v0, p0

    sget v1, Lcom/szpu/nativeapp/R$id;->course_period_1:I

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    const-string v4, ""

    const/4 v5, 0x0

    invoke-static/range {v0 .. v5}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->setChronometer(Landroid/widget/RemoteViews;IJLjava/lang/String;Z)V

    return-void
.end method
