//
//  MFDefine.h

#ifndef MFSDK_MFDEFINE_h
#define MFSDK_MFDEFINE_h

#define kNotificationDidChangeMediaState        @"kNotificationDidChangeMediaState"
#define DEFAULTICON                             [MFResourceCenter imageNamed:@"headIcon.png"]
#define DEFAULTICONNAME                         @"headIcon.png"

//模版id
#define DIALOG_TEMPLATE_MESSAGE                 @"1"
#define DIALOG_TEMPLATE_SHARE                   @"1001"
#define DIALOG_TEMPLATE_BANNER                  @"1002"
#define DIALOG_TEMPLATE_BANNERNOTITLE           @"1003"
#define DIALOG_TEMPLATE_UNKNOW                  @"10000"

//访问KEY PKey_UI
#define KEY_DATASOURCE                          @"sources"
#define KEY_WIDGET                              @"widget"
#define KEY_WIDGET_NODE                         @"widgetNode"
#define KEY_WIDGET_STYLE                        @"widgetStyle"
#define KEY_WIDGET_DATA_BINDING                 @"widgetDataBinding"
#define KEY_WIDGET_EVENTS                       @"widgetEvents"
#define KEY_WIDGET_INFO                         @"widgetInfo"

#define KEY_WIDGET_ALIGNMENTTYPE                @"alignmentType"
#define KEY_WIDGET_LEFT                         @"left"
#define KEY_WIDGET_TOP                          @"top"
#define KEY_WIDGET_WIDTH                        @"width"
#define KEY_WIDGET_HEIGHT                       @"height"
#define KEY_WIDGET_SIZE                         @"widgetSize"
#define KEYWORD_FRAME                           @"frame"

//关键字
#define KEYWORD_SEED                            @"seed"
#define KEYWORD_ID                              @"id"
#define KEYWORD_TEMPLATE_ID                     @"templateId"
#define KEYWORD_DS_DATA                         @"data"
#define KEYWORD_DATASOURCEKEY                   @"dsKey"
#define KEYWORD_NUMBEROFLINES                   @"numberOfLines"

//参数
#define L_OPT_USERID                            @"tUserId"
#define L_OPT_USERNAME                          @"tUserName"
#define L_OPT_RETURNID                          @"returnAppId"
#define L_OPT_USERTYPE                          @"tUserType"
#define L_OPT_HIDEMENU                          @"hideMenu"
#define L_OPT_FORCEREQUEST                      @"forceRequest"

#define STANDARD_WIDTH                          320
#define IMAGEWIDTH                              160
#define IMAGEHEIGHT                             160
#define kDeviceWidth                            [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight                           [UIScreen mainScreen].bounds.size.height

#define sectionTimeHeaderHeight                 0
#define sectionCellHeight                       25
#define sectionHeaderHeight                     15
#define sectionFooterHeight                     15
#define tipsHeightSpace                          4
#define tipsWidthSpace                           4
#define cellHeaderFontSize                      12
#define cellFooterFontSize                      13

#define kMFOnKeyLongPressEventKey               @"onKeyLongPress"
#define kMFOnClickEventKey                      @"onclick"
#define kMFOnSwipeEventKey                      @"onswipe"
#define kMFOnLoadEventKey                       @"onload"
#define kMFOnUnloadEventKey                     @"onunload"
#define kMFOnPageShowEventKey                   @"onpageshow"
#define kMFOnPageHideEventKey                   @"onpagehide"

typedef enum {
    MFBGImageTypeWhite = 0,
    MFBGImageTypeWhite2 = 1,
    MFBGImageTypeBlue = 2,
    MFBGImageTypeBlue2 = 3,
    MFBGImageTypeBlueWhite = 4,
    
} MFBGImageType;

typedef enum {
    MFAlignmentTypeLeft = 0,
    MFAlignmentTypeCenter = 1,
    MFAlignmentTypeRight = 2,
    
} MFAlignmentType;

typedef enum {
    MFLayoutTypeStretch = 0,
    MFLayoutTypeAbsolute = 1,
    MFLayoutTypeNone = 2,
} MFLayoutType;

typedef enum {
    MFCellStatusNone = 0,
    MFCellStatusRuning,
    MFCellStatusFinish,
    MFCellStatusNotSend,
    MFCellStatusFail,
    
} MFCellStatusType;

typedef enum {
    MFChatMessageTypeOrdinary = 0,
    MFChatMessageTypeReminder,
    MFChatMessageTypeInvalid,
    
} MFChatMessageType;

#endif
