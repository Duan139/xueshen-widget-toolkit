.class final Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer;
.super Ljava/lang/Object;
.source "TimetableWidgetRenderer.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer$Size;
    }
.end annotation


# direct methods
.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static attachClick(Landroid/content/Context;Landroid/widget/RemoteViews;)V
    .locals 3

    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/szpu/nativeapp/TimetableWeekActivity;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const/high16 v1, 0x14000000

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setFlags(I)Landroid/content/Intent;

    const/4 v1, 0x0

    const/high16 v2, 0xc000000

    invoke-static {p0, v1, v0, v2}, Landroid/app/PendingIntent;->getActivity(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object p0

    sget v0, Lcom/szpu/nativeapp/R$id;->widget_root:I

    invoke-virtual {p1, v0, p0}, Landroid/widget/RemoteViews;->setOnClickPendingIntent(ILandroid/app/PendingIntent;)V

    return-void
.end method

.method private static bindCourseRows(Landroid/widget/RemoteViews;Ljava/util/List;IZ)V
    .locals 16
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/widget/RemoteViews;",
            "Ljava/util/List<",
            "Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;",
            ">;IZ)V"
        }
    .end annotation

    move-object/from16 v0, p0

    move/from16 v1, p2

    sget v2, Lcom/szpu/nativeapp/R$id;->course_row_1:I

    sget v3, Lcom/szpu/nativeapp/R$id;->course_row_2:I

    sget v4, Lcom/szpu/nativeapp/R$id;->course_row_3:I

    sget v5, Lcom/szpu/nativeapp/R$id;->course_row_4:I

    sget v6, Lcom/szpu/nativeapp/R$id;->course_row_5:I

    sget v7, Lcom/szpu/nativeapp/R$id;->course_row_6:I

    filled-new-array/range {v2 .. v7}, [I

    move-result-object v2

    sget v3, Lcom/szpu/nativeapp/R$id;->course_bar_1:I

    sget v4, Lcom/szpu/nativeapp/R$id;->course_bar_2:I

    sget v5, Lcom/szpu/nativeapp/R$id;->course_bar_3:I

    sget v6, Lcom/szpu/nativeapp/R$id;->course_bar_4:I

    sget v7, Lcom/szpu/nativeapp/R$id;->course_bar_5:I

    sget v8, Lcom/szpu/nativeapp/R$id;->course_bar_6:I

    filled-new-array/range {v3 .. v8}, [I

    move-result-object v3

    sget v4, Lcom/szpu/nativeapp/R$id;->course_title_1:I

    sget v5, Lcom/szpu/nativeapp/R$id;->course_title_2:I

    sget v6, Lcom/szpu/nativeapp/R$id;->course_title_3:I

    sget v7, Lcom/szpu/nativeapp/R$id;->course_title_4:I

    sget v8, Lcom/szpu/nativeapp/R$id;->course_title_5:I

    sget v9, Lcom/szpu/nativeapp/R$id;->course_title_6:I

    filled-new-array/range {v4 .. v9}, [I

    move-result-object v4

    sget v5, Lcom/szpu/nativeapp/R$id;->course_period_1:I

    sget v6, Lcom/szpu/nativeapp/R$id;->course_period_2:I

    sget v7, Lcom/szpu/nativeapp/R$id;->course_period_3:I

    sget v8, Lcom/szpu/nativeapp/R$id;->course_period_4:I

    sget v9, Lcom/szpu/nativeapp/R$id;->course_period_5:I

    sget v10, Lcom/szpu/nativeapp/R$id;->course_period_6:I

    filled-new-array/range {v5 .. v10}, [I

    move-result-object v5

    sget v6, Lcom/szpu/nativeapp/R$id;->course_place_1:I

    sget v7, Lcom/szpu/nativeapp/R$id;->course_place_2:I

    sget v8, Lcom/szpu/nativeapp/R$id;->course_place_3:I

    sget v9, Lcom/szpu/nativeapp/R$id;->course_place_4:I

    sget v10, Lcom/szpu/nativeapp/R$id;->course_place_5:I

    sget v11, Lcom/szpu/nativeapp/R$id;->course_place_6:I

    filled-new-array/range {v6 .. v11}, [I

    move-result-object v6

    invoke-interface/range {p1 .. p1}, Ljava/util/List;->size()I

    move-result v7

    invoke-static {v7, v1}, Ljava/lang/Math;->min(II)I

    move-result v7

    const/4 v8, 0x0

    move v9, v8

    :goto_0
    const/16 v10, 0x8

    if-ge v9, v1, :cond_4

    const/4 v11, 0x6

    if-lt v9, v11, :cond_0

    goto :goto_2

    :cond_0
    if-ge v9, v7, :cond_3

    move-object/from16 v11, p1

    invoke-interface {v11, v9}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;

    aget v13, v2, v9

    invoke-virtual {v0, v13, v8}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    aget v13, v3, v9

    const-string v14, "setBackgroundColor"

    iget v15, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->colorArgb:I

    invoke-virtual {v0, v13, v14, v15}, Landroid/widget/RemoteViews;->setInt(ILjava/lang/String;I)V

    aget v13, v4, v9

    iget-object v14, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->title:Ljava/lang/String;

    invoke-virtual {v0, v13, v14}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    if-eqz p3, :cond_1

    aget v13, v5, v9

    invoke-static {v12}, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer;->compactSubtitle(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v0, v13, v12}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    aget v12, v6, v9

    invoke-virtual {v0, v12, v10}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    goto :goto_1

    :cond_1
    aget v13, v5, v9

    iget-object v14, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->periodText:Ljava/lang/String;

    invoke-virtual {v0, v13, v14}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    iget-object v13, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->detailText:Ljava/lang/String;

    if-eqz v13, :cond_2

    iget-object v13, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->detailText:Ljava/lang/String;

    invoke-virtual {v13}, Ljava/lang/String;->isEmpty()Z

    move-result v13

    if-nez v13, :cond_2

    aget v10, v6, v9

    invoke-virtual {v0, v10, v8}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    aget v10, v6, v9

    if-nez v9, :cond_place_hide

    invoke-static {v12}, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer;->detailLines(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v0, v10, v12}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    goto :goto_1

    :cond_place_hide
    const/16 v10, 0x8

    aget v11, v6, v9

    invoke-virtual {v0, v11, v10}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    goto :goto_1

    :cond_2
    aget v12, v6, v9

    invoke-virtual {v0, v12, v10}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    goto :goto_1

    :cond_3
    move-object/from16 v11, p1

    aget v12, v2, v9

    invoke-virtual {v0, v12, v10}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    :goto_1
    add-int/lit8 v9, v9, 0x1

    goto :goto_0

    :cond_4
    :goto_2
    move-object/from16 v11, p1

    invoke-interface/range {p1 .. p1}, Ljava/util/List;->size()I

    move-result v2

    if-le v2, v1, :cond_5

    sget v2, Lcom/szpu/nativeapp/R$id;->more_courses:I

    invoke-virtual {v0, v2, v8}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    sget v2, Lcom/szpu/nativeapp/R$id;->more_courses:I

    new-instance v3, Ljava/lang/StringBuilder;

    const-string/jumbo v4, "\u8fd8\u6709 "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-interface/range {p1 .. p1}, Ljava/util/List;->size()I

    move-result v4

    sub-int/2addr v4, v1

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u95e8\u2026"

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v2, v1}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    goto :goto_3

    :cond_5
    sget v1, Lcom/szpu/nativeapp/R$id;->more_courses:I

    invoke-virtual {v0, v1, v10}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    :goto_3
    return-void
.end method

.method private static bindFooter(Landroid/widget/RemoteViews;Ljava/lang/String;)V
    .locals 2

    if-eqz p1, :cond_0

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_0

    sget v0, Lcom/szpu/nativeapp/R$id;->footer_text:I

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    sget v0, Lcom/szpu/nativeapp/R$id;->footer_text:I

    invoke-virtual {p0, v0, p1}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    goto :goto_0

    :cond_0
    sget p1, Lcom/szpu/nativeapp/R$id;->footer_text:I

    const/16 v0, 0x8

    invoke-virtual {p0, p1, v0}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    :goto_0
    return-void
.end method

.method private static bindLarge(Landroid/widget/RemoteViews;Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;)V
    .locals 18

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    iget-boolean v2, v1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->empty:Z

    const/16 v3, 0x8

    const/4 v4, 0x0

    if-eqz v2, :cond_0

    sget v1, Lcom/szpu/nativeapp/R$id;->week_content:I

    invoke-virtual {v0, v1, v3}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    sget v1, Lcom/szpu/nativeapp/R$id;->empty_content:I

    invoke-virtual {v0, v1, v4}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    return-void

    :cond_0
    sget v2, Lcom/szpu/nativeapp/R$id;->week_content:I

    invoke-virtual {v0, v2, v4}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    sget v2, Lcom/szpu/nativeapp/R$id;->empty_content:I

    invoke-virtual {v0, v2, v3}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    sget v2, Lcom/szpu/nativeapp/R$id;->week_title:I

    const-string/jumbo v5, "\u672c\u5468\u8bfe\u8868"

    invoke-virtual {v0, v2, v5}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    sget v2, Lcom/szpu/nativeapp/R$id;->week_badge:I

    new-instance v5, Ljava/lang/StringBuilder;

    const-string/jumbo v6, "\u7b2c "

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v6, v1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->week:I

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " \u5468"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v2, v5}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    sget v2, Lcom/szpu/nativeapp/R$id;->term_text:I

    iget-object v5, v1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->term:Ljava/lang/String;

    if-eqz v5, :cond_1

    iget-object v5, v1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->term:Ljava/lang/String;

    goto :goto_0

    :cond_1
    const-string v5, ""

    :goto_0
    invoke-virtual {v0, v2, v5}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    sget v6, Lcom/szpu/nativeapp/R$id;->day_col_1:I

    sget v7, Lcom/szpu/nativeapp/R$id;->day_col_2:I

    sget v8, Lcom/szpu/nativeapp/R$id;->day_col_3:I

    sget v9, Lcom/szpu/nativeapp/R$id;->day_col_4:I

    sget v10, Lcom/szpu/nativeapp/R$id;->day_col_5:I

    sget v11, Lcom/szpu/nativeapp/R$id;->day_col_6:I

    sget v12, Lcom/szpu/nativeapp/R$id;->day_col_7:I

    filled-new-array/range {v6 .. v12}, [I

    move-result-object v2

    sget v5, Lcom/szpu/nativeapp/R$id;->day1_c1:I

    sget v6, Lcom/szpu/nativeapp/R$id;->day1_c2:I

    sget v7, Lcom/szpu/nativeapp/R$id;->day1_c3:I

    filled-new-array {v5, v6, v7}, [I

    move-result-object v8

    sget v5, Lcom/szpu/nativeapp/R$id;->day2_c1:I

    sget v6, Lcom/szpu/nativeapp/R$id;->day2_c2:I

    sget v7, Lcom/szpu/nativeapp/R$id;->day2_c3:I

    filled-new-array {v5, v6, v7}, [I

    move-result-object v9

    sget v5, Lcom/szpu/nativeapp/R$id;->day3_c1:I

    sget v6, Lcom/szpu/nativeapp/R$id;->day3_c2:I

    sget v7, Lcom/szpu/nativeapp/R$id;->day3_c3:I

    filled-new-array {v5, v6, v7}, [I

    move-result-object v10

    sget v5, Lcom/szpu/nativeapp/R$id;->day4_c1:I

    sget v6, Lcom/szpu/nativeapp/R$id;->day4_c2:I

    sget v7, Lcom/szpu/nativeapp/R$id;->day4_c3:I

    filled-new-array {v5, v6, v7}, [I

    move-result-object v11

    sget v5, Lcom/szpu/nativeapp/R$id;->day5_c1:I

    sget v6, Lcom/szpu/nativeapp/R$id;->day5_c2:I

    sget v7, Lcom/szpu/nativeapp/R$id;->day5_c3:I

    filled-new-array {v5, v6, v7}, [I

    move-result-object v12

    sget v5, Lcom/szpu/nativeapp/R$id;->day6_c1:I

    sget v6, Lcom/szpu/nativeapp/R$id;->day6_c2:I

    sget v7, Lcom/szpu/nativeapp/R$id;->day6_c3:I

    filled-new-array {v5, v6, v7}, [I

    move-result-object v13

    sget v5, Lcom/szpu/nativeapp/R$id;->day7_c1:I

    sget v6, Lcom/szpu/nativeapp/R$id;->day7_c2:I

    sget v7, Lcom/szpu/nativeapp/R$id;->day7_c3:I

    filled-new-array {v5, v6, v7}, [I

    move-result-object v14

    filled-new-array/range {v8 .. v14}, [[I

    move-result-object v5

    sget v6, Lcom/szpu/nativeapp/R$id;->day1_name:I

    sget v7, Lcom/szpu/nativeapp/R$id;->day2_name:I

    sget v8, Lcom/szpu/nativeapp/R$id;->day3_name:I

    sget v9, Lcom/szpu/nativeapp/R$id;->day4_name:I

    sget v10, Lcom/szpu/nativeapp/R$id;->day5_name:I

    sget v11, Lcom/szpu/nativeapp/R$id;->day6_name:I

    sget v12, Lcom/szpu/nativeapp/R$id;->day7_name:I

    filled-new-array/range {v6 .. v12}, [I

    move-result-object v6

    sget v7, Lcom/szpu/nativeapp/R$id;->day1_date:I

    sget v8, Lcom/szpu/nativeapp/R$id;->day2_date:I

    sget v9, Lcom/szpu/nativeapp/R$id;->day3_date:I

    sget v10, Lcom/szpu/nativeapp/R$id;->day4_date:I

    sget v11, Lcom/szpu/nativeapp/R$id;->day5_date:I

    sget v12, Lcom/szpu/nativeapp/R$id;->day6_date:I

    sget v13, Lcom/szpu/nativeapp/R$id;->day7_date:I

    filled-new-array/range {v7 .. v13}, [I

    move-result-object v7

    sget v8, Lcom/szpu/nativeapp/R$id;->day1_header:I

    sget v9, Lcom/szpu/nativeapp/R$id;->day2_header:I

    sget v10, Lcom/szpu/nativeapp/R$id;->day3_header:I

    sget v11, Lcom/szpu/nativeapp/R$id;->day4_header:I

    sget v12, Lcom/szpu/nativeapp/R$id;->day5_header:I

    sget v13, Lcom/szpu/nativeapp/R$id;->day6_header:I

    sget v14, Lcom/szpu/nativeapp/R$id;->day7_header:I

    filled-new-array/range {v8 .. v14}, [I

    move-result-object v8

    sget v9, Lcom/szpu/nativeapp/R$id;->day1_empty:I

    sget v10, Lcom/szpu/nativeapp/R$id;->day2_empty:I

    sget v11, Lcom/szpu/nativeapp/R$id;->day3_empty:I

    sget v12, Lcom/szpu/nativeapp/R$id;->day4_empty:I

    sget v13, Lcom/szpu/nativeapp/R$id;->day5_empty:I

    sget v14, Lcom/szpu/nativeapp/R$id;->day6_empty:I

    sget v15, Lcom/szpu/nativeapp/R$id;->day7_empty:I

    filled-new-array/range {v9 .. v15}, [I

    move-result-object v9

    sget v10, Lcom/szpu/nativeapp/R$id;->day1_more:I

    sget v11, Lcom/szpu/nativeapp/R$id;->day2_more:I

    sget v12, Lcom/szpu/nativeapp/R$id;->day3_more:I

    sget v13, Lcom/szpu/nativeapp/R$id;->day4_more:I

    sget v14, Lcom/szpu/nativeapp/R$id;->day5_more:I

    sget v15, Lcom/szpu/nativeapp/R$id;->day6_more:I

    sget v16, Lcom/szpu/nativeapp/R$id;->day7_more:I

    filled-new-array/range {v10 .. v16}, [I

    move-result-object v10

    move v11, v4

    :goto_1
    const/4 v12, 0x7

    if-ge v11, v12, :cond_c

    iget-object v12, v1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->weekColumns:Ljava/util/List;

    invoke-interface {v12}, Ljava/util/List;->size()I

    move-result v12

    if-ge v11, v12, :cond_2

    iget-object v12, v1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->weekColumns:Ljava/util/List;

    invoke-interface {v12, v11}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$DayColumn;

    goto :goto_2

    :cond_2
    const/4 v12, 0x0

    :goto_2
    if-nez v12, :cond_3

    move v12, v4

    move v4, v3

    goto/16 :goto_a

    :cond_3
    iget-object v13, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$DayColumn;->title:Ljava/lang/String;

    invoke-virtual {v13}, Ljava/lang/String;->length()I

    move-result v13

    if-lez v13, :cond_4

    iget-object v13, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$DayColumn;->title:Ljava/lang/String;

    iget-object v14, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$DayColumn;->title:Ljava/lang/String;

    invoke-virtual {v14}, Ljava/lang/String;->length()I

    move-result v14

    add-int/lit8 v14, v14, -0x1

    invoke-virtual {v13, v14}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v13

    goto :goto_3

    :cond_4
    iget-object v13, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$DayColumn;->title:Ljava/lang/String;

    :goto_3
    aget v14, v6, v11

    invoke-virtual {v0, v14, v13}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    iget-object v13, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$DayColumn;->dateLine:Ljava/lang/String;

    if-eqz v13, :cond_5

    iget-object v13, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$DayColumn;->dateLine:Ljava/lang/String;

    invoke-virtual {v13}, Ljava/lang/String;->isEmpty()Z

    move-result v13

    if-nez v13, :cond_5

    aget v13, v7, v11

    invoke-virtual {v0, v13, v4}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    aget v13, v7, v11

    iget-object v14, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$DayColumn;->dateLine:Ljava/lang/String;

    const/16 v15, 0x2d

    const/16 v4, 0x2f

    invoke-virtual {v14, v15, v4}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v13, v4}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    goto :goto_4

    :cond_5
    aget v4, v7, v11

    invoke-virtual {v0, v4, v3}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    :goto_4
    iget-boolean v4, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$DayColumn;->isToday:Z

    const-string v13, "setBackgroundColor"

    if-eqz v4, :cond_6

    aget v4, v8, v11

    const v14, 0x1f007af5

    invoke-virtual {v0, v4, v13, v14}, Landroid/widget/RemoteViews;->setInt(ILjava/lang/String;I)V

    const/4 v14, 0x0

    goto :goto_5

    :cond_6
    aget v4, v8, v11

    const/4 v14, 0x0

    invoke-virtual {v0, v4, v13, v14}, Landroid/widget/RemoteViews;->setInt(ILjava/lang/String;I)V

    :goto_5
    iget-object v4, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$DayColumn;->lines:Ljava/util/List;

    invoke-interface {v4}, Ljava/util/List;->isEmpty()Z

    move-result v4

    const/4 v15, 0x3

    if-eqz v4, :cond_8

    aget v4, v9, v11

    invoke-virtual {v0, v4, v14}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    const/4 v4, 0x0

    :goto_6
    if-ge v4, v15, :cond_7

    aget-object v12, v5, v11

    aget v12, v12, v4

    invoke-virtual {v0, v12, v3}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    add-int/lit8 v4, v4, 0x1

    goto :goto_6

    :cond_7
    aget v4, v10, v11

    invoke-virtual {v0, v4, v3}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    move v4, v3

    goto/16 :goto_9

    :cond_8
    aget v4, v9, v11

    invoke-virtual {v0, v4, v3}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    iget-object v4, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$DayColumn;->lines:Ljava/util/List;

    invoke-interface {v4}, Ljava/util/List;->size()I

    move-result v4

    invoke-static {v4, v15}, Ljava/lang/Math;->min(II)I

    move-result v4

    const/4 v14, 0x0

    :goto_7
    if-ge v14, v15, :cond_a

    if-ge v14, v4, :cond_9

    iget-object v15, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$DayColumn;->lines:Ljava/util/List;

    invoke-interface {v15, v14}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v15

    check-cast v15, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;

    aget-object v17, v5, v11

    aget v3, v17, v14

    move/from16 v17, v4

    const/4 v4, 0x0

    invoke-virtual {v0, v3, v4}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    aget-object v3, v5, v11

    aget v3, v3, v14

    invoke-static {v15}, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer;->compactWeekChipText(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v3, v4}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    aget-object v3, v5, v11

    aget v3, v3, v14

    iget v4, v15, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->colorArgb:I

    const/16 v15, 0x48

    invoke-static {v4, v15}, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer;->withAlpha(II)I

    move-result v4

    invoke-virtual {v0, v3, v13, v4}, Landroid/widget/RemoteViews;->setInt(ILjava/lang/String;I)V

    goto :goto_8

    :cond_9
    move/from16 v17, v4

    aget-object v3, v5, v11

    aget v3, v3, v14

    const/16 v4, 0x8

    invoke-virtual {v0, v3, v4}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    :goto_8
    add-int/lit8 v14, v14, 0x1

    move/from16 v4, v17

    const/16 v3, 0x8

    const/4 v15, 0x3

    goto :goto_7

    :cond_a
    iget-object v3, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$DayColumn;->lines:Ljava/util/List;

    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v3

    const/4 v4, 0x3

    if-le v3, v4, :cond_b

    aget v3, v10, v11

    const/4 v13, 0x0

    invoke-virtual {v0, v3, v13}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    aget v3, v10, v11

    new-instance v13, Ljava/lang/StringBuilder;

    const-string v14, "+"

    invoke-direct {v13, v14}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v12, v12, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$DayColumn;->lines:Ljava/util/List;

    invoke-interface {v12}, Ljava/util/List;->size()I

    move-result v12

    sub-int/2addr v12, v4

    invoke-virtual {v13, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v3, v4}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    const/16 v4, 0x8

    goto :goto_9

    :cond_b
    aget v3, v10, v11

    const/16 v4, 0x8

    invoke-virtual {v0, v3, v4}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    :goto_9
    aget v3, v2, v11

    const/4 v12, 0x0

    invoke-virtual {v0, v3, v12}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    :goto_a
    add-int/lit8 v11, v11, 0x1

    move v3, v4

    move v4, v12

    goto/16 :goto_1

    :cond_c
    iget-object v1, v1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->footer:Ljava/lang/String;

    invoke-static {v0, v1}, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer;->bindFooter(Landroid/widget/RemoteViews;Ljava/lang/String;)V

    return-void
.end method

.method private static detailLines(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)Ljava/lang/String;
    .locals 3

    iget-object v0, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->detailText:Ljava/lang/String;

    if-eqz v0, :cond_0

    const-string v1, " \u00b7 "

    const-string v2, "\n"

    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v0

    :cond_0
    return-object v0
.end method

.method private static bindMedium(Landroid/widget/RemoteViews;Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;)V
    .locals 6

    invoke-static {p0}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->stopCountdown(Landroid/widget/RemoteViews;)V

    const/4 v0, 0x2

    const/4 v1, 0x0

    invoke-static {p0, p1, v0, v1}, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer;->bindToday(Landroid/widget/RemoteViews;Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;IZ)V

    iget-boolean v2, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->empty:Z

    if-eqz v2, :cond_0

    return-void

    :cond_0
    iget-object v2, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->todayLines:Ljava/util/List;

    if-eqz v2, :cond_1

    invoke-static {v2}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->selectUpcomingLines(Ljava/util/List;)Ljava/util/List;

    move-result-object v3

    const/4 v4, 0x6

    invoke-static {p0, v3, v4, v1}, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer;->bindCourseRows(Landroid/widget/RemoteViews;Ljava/util/List;IZ)V

    invoke-static {p0, v3}, Lcom/szpu/nativeapp/widget/WidgetCountdownHelper;->bindCountdown(Landroid/widget/RemoteViews;Ljava/util/List;)V

    invoke-interface {v3}, Ljava/util/List;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_1

    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_1

    sget v4, Lcom/szpu/nativeapp/R$id;->no_class_today:I

    const-string/jumbo v5, "\u5f53\u524d\u65e0\u53ef\u786e\u8ba4\u8bfe\u65f6\uff0c\u672a\u663e\u793a\u5012\u8ba1\u65f6"

    invoke-virtual {p0, v4, v5}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    invoke-virtual {p0, v4, v1}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    sget v4, Lcom/szpu/nativeapp/R$id;->course_list:I

    const/16 v5, 0x8

    invoke-virtual {p0, v4, v5}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    :cond_1
    return-void
.end method

.method private static bindToday(Landroid/widget/RemoteViews;Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;IZ)V
    .locals 6

    iget-boolean v0, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->empty:Z

    const/4 v1, 0x0

    const/16 v2, 0x8

    if-eqz v0, :cond_0

    sget p1, Lcom/szpu/nativeapp/R$id;->today_content:I

    invoke-virtual {p0, p1, v2}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    sget p1, Lcom/szpu/nativeapp/R$id;->empty_content:I

    invoke-virtual {p0, p1, v1}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    return-void

    :cond_0
    sget v0, Lcom/szpu/nativeapp/R$id;->today_content:I

    invoke-virtual {p0, v0, v1}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    sget v0, Lcom/szpu/nativeapp/R$id;->empty_content:I

    invoke-virtual {p0, v0, v2}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    if-eqz p3, :cond_1

    sget v0, Lcom/szpu/nativeapp/R$id;->weekday_title:I

    iget-object v3, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->weekdayLabel:Ljava/lang/String;

    iget-object v4, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->todayDateLine:Ljava/lang/String;

    invoke-static {v3, v4}, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer;->headerTitle(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v0, v3}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    sget v0, Lcom/szpu/nativeapp/R$id;->today_date:I

    invoke-virtual {p0, v0, v2}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    goto :goto_1

    :cond_1
    sget v0, Lcom/szpu/nativeapp/R$id;->weekday_title:I

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v4, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->weekdayLabel:Ljava/lang/String;

    if-eqz v4, :cond_2

    iget-object v4, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->weekdayLabel:Ljava/lang/String;

    goto :goto_0

    :cond_2
    const-string/jumbo v4, "\u4eca\u65e5"

    :goto_0
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string/jumbo v4, "\u8bfe\u8868"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v0, v3}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    iget-object v0, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->todayDateLine:Ljava/lang/String;

    if-eqz v0, :cond_3

    iget-object v0, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->todayDateLine:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_3

    sget v0, Lcom/szpu/nativeapp/R$id;->today_date:I

    invoke-virtual {p0, v0, v1}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    sget v0, Lcom/szpu/nativeapp/R$id;->today_date:I

    iget-object v3, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->todayDateLine:Ljava/lang/String;

    const/16 v4, 0x2d

    const/16 v5, 0x2f

    invoke-virtual {v3, v4, v5}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v0, v3}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    goto :goto_1

    :cond_3
    sget v0, Lcom/szpu/nativeapp/R$id;->today_date:I

    invoke-virtual {p0, v0, v2}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    :goto_1
    sget v0, Lcom/szpu/nativeapp/R$id;->week_badge:I

    new-instance v3, Ljava/lang/StringBuilder;

    const-string/jumbo v4, "\u7b2c"

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v4, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->week:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string/jumbo v4, "\u5468"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v0, v3}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    sget v0, Lcom/szpu/nativeapp/R$id;->term_text:I

    iget-object v3, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->term:Ljava/lang/String;

    if-eqz v3, :cond_4

    iget-object v3, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->term:Ljava/lang/String;

    goto :goto_2

    :cond_4
    const-string v3, ""

    :goto_2
    invoke-virtual {p0, v0, v3}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    iget-object v0, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->todayLines:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_5

    sget p2, Lcom/szpu/nativeapp/R$id;->no_class_today:I

    invoke-virtual {p0, p2, v1}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    sget p2, Lcom/szpu/nativeapp/R$id;->course_list:I

    invoke-virtual {p0, p2, v2}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    goto :goto_3

    :cond_5
    sget v0, Lcom/szpu/nativeapp/R$id;->no_class_today:I

    invoke-virtual {p0, v0, v2}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    sget v0, Lcom/szpu/nativeapp/R$id;->course_list:I

    invoke-virtual {p0, v0, v1}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    iget-object v0, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->todayLines:Ljava/util/List;

    invoke-static {p0, v0, p2, p3}, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer;->bindCourseRows(Landroid/widget/RemoteViews;Ljava/util/List;IZ)V

    :goto_3
    iget-object p1, p1, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;->footer:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer;->bindFooter(Landroid/widget/RemoteViews;Ljava/lang/String;)V

    return-void
.end method

.method static build(Landroid/content/Context;Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer$Size;Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;)Landroid/widget/RemoteViews;
    .locals 3

    sget-object v0, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer$1;->$SwitchMap$com$szpu$nativeapp$widget$TimetableWidgetRenderer$Size:[I

    invoke-virtual {p1}, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer$Size;->ordinal()I

    move-result p1

    aget p1, v0, p1

    const/4 v0, 0x1

    if-eq p1, v0, :cond_1

    const/4 v1, 0x2

    if-eq p1, v1, :cond_0

    new-instance p1, Landroid/widget/RemoteViews;

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    sget v2, Lcom/szpu/nativeapp/R$layout;->widget_timetable_small:I

    invoke-direct {p1, v1, v2}, Landroid/widget/RemoteViews;-><init>(Ljava/lang/String;I)V

    const/4 v1, 0x3

    invoke-static {p1, p2, v1, v0}, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer;->bindToday(Landroid/widget/RemoteViews;Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;IZ)V

    goto :goto_0

    :cond_0
    new-instance p1, Landroid/widget/RemoteViews;

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    sget v1, Lcom/szpu/nativeapp/R$layout;->widget_timetable_medium:I

    invoke-direct {p1, v0, v1}, Landroid/widget/RemoteViews;-><init>(Ljava/lang/String;I)V

    invoke-static {p1, p2}, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer;->bindMedium(Landroid/widget/RemoteViews;Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;)V

    goto :goto_0

    :cond_1
    new-instance p1, Landroid/widget/RemoteViews;

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    sget v1, Lcom/szpu/nativeapp/R$layout;->widget_timetable_large:I

    invoke-direct {p1, v0, v1}, Landroid/widget/RemoteViews;-><init>(Ljava/lang/String;I)V

    invoke-static {p1, p2}, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer;->bindLarge(Landroid/widget/RemoteViews;Lcom/szpu/nativeapp/widget/TimetableWidgetEntry;)V

    :goto_0
    invoke-static {p0, p1}, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer;->attachClick(Landroid/content/Context;Landroid/widget/RemoteViews;)V

    return-object p1
.end method

.method private static chipText(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)Ljava/lang/String;
    .locals 3

    new-instance v0, Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->title:Ljava/lang/String;

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const/16 v1, 0xa

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->periodText:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->detailText:Ljava/lang/String;

    if-eqz v2, :cond_0

    iget-object v2, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->detailText:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_0

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->detailText:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_0
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static compactSubtitle(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)Ljava/lang/String;
    .locals 3

    iget-object v0, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->periodText:Ljava/lang/String;

    const-string v1, ""

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->periodText:Ljava/lang/String;

    goto :goto_0

    :cond_0
    move-object v0, v1

    :goto_0
    iget-object v2, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->detailText:Ljava/lang/String;

    if-eqz v2, :cond_1

    iget-object p0, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->detailText:Ljava/lang/String;

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    :cond_1
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result p0

    if-eqz p0, :cond_2

    return-object v0

    :cond_2
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result p0

    if-eqz p0, :cond_3

    return-object v1

    :cond_3
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " \u00b7 "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static compactWeekChipText(Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;)Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->title:Ljava/lang/String;

    if-nez v0, :cond_0

    const-string p0, ""

    goto :goto_0

    :cond_0
    iget-object p0, p0, Lcom/szpu/nativeapp/widget/TimetableWidgetEntry$Line;->title:Ljava/lang/String;

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    :goto_0
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    const-string/jumbo p0, "\u8bfe\u7a0b"

    :cond_1
    return-object p0
.end method

.method static detectSize(Landroid/os/Bundle;)Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer$Size;
    .locals 3

    const-string v0, "appWidgetMinWidth"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v0

    const-string v2, "appWidgetMinHeight"

    invoke-virtual {p0, v2, v1}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result p0

    const/16 v1, 0xb4

    if-ge p0, v1, :cond_2

    const/16 v1, 0xfa

    if-lt v0, v1, :cond_0

    const/16 v2, 0x96

    if-lt p0, v2, :cond_0

    goto :goto_0

    :cond_0
    if-lt v0, v1, :cond_1

    sget-object p0, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer$Size;->MEDIUM:Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer$Size;

    return-object p0

    :cond_1
    sget-object p0, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer$Size;->SMALL:Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer$Size;

    return-object p0

    :cond_2
    :goto_0
    sget-object p0, Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer$Size;->LARGE:Lcom/szpu/nativeapp/widget/TimetableWidgetRenderer$Size;

    return-object p0
.end method

.method private static headerTitle(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const-string/jumbo p0, "\u4eca\u65e5"

    :goto_0
    if-eqz p1, :cond_2

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_1

    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " \u00b7 "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 p0, 0x2d

    const/16 v1, 0x2f

    invoke-virtual {p1, p0, v1}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_2
    :goto_1
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string/jumbo p0, "\u8bfe\u8868"

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static withAlpha(II)I
    .locals 1

    shl-int/lit8 p1, p1, 0x18

    const v0, 0xffffff

    and-int/2addr p0, v0

    or-int/2addr p0, p1

    return p0
.end method
