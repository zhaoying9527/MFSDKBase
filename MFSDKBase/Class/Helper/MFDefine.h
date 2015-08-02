//
//  MFDefine.h

#ifndef MFSDK_MFDEFINE_h
#define MFSDK_MFDEFINE_h

#define SYNTHESIZE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#define DEFAULTICONNAME                         @"headIcon.png"
#define DEFAULTICON                             [MFResourceCenter imageNamed:DEFAULTICONNAME]


//模版id
#define DIALOG_TEMPLATE_UNKNOW                  @"tid-10000"

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
#define KEY_WIDGET_MAX_WIDTH                    @"max-width"
#define KEY_WIDGET_HEIGHT                       @"height"
#define KEY_WIDGET_MAX_HEIGHT                   @"max-height"
#define KEY_WIDGET_SIZE                         @"widgetSize"
#define KEYWORD_FRAME                           @"frame"

//关键字
#define KEYWORD_SEED                            @"seed"
#define KEYWORD_ID                              @"id"
#define KEYWORD_DS_DATA                         @"data"
#define KEYWORD_DATASOURCEKEY                   @"dsKey"
#define KEYWORD_LINK                            @"link"
#define KEYWORD_NUMBEROFLINES                   @"numberOfLines"


#define STANDARD_WIDTH                          320
#define IMAGEWIDTH                              120
#define IMAGEHEIGHT                             120
#define kDeviceWidth                            [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight                           [UIScreen mainScreen].bounds.size.height

#define sectionTimeHeaderHeight                 0
#define sectionCellHeight                       20
#define sectionHeaderHeight                     15
#define sectionFooterHeight                     15
#define cellHeaderFontSize                      12
#define cellFooterFontSize                      13
#define tipsHeightSpace                         4
#define tipsWidthSpace                          4

#define kMFOnLongPressEvent                     @"longpress"
#define kMFOnClickEvent                         @"onclick"
#define kMFOnDbClickEvent                       @"ondbclick"
#define kMFOnSwipeEvent                         @"onswipe"
#define kMFOnLoadEvent                          @"onload"
#define kMFOnUnloadEvent                        @"onunload"
#define kMFOnPageShowEvent                      @"onpageshow"
#define kMFOnPageHideEvent                      @"onpagehide"

#define kLongPressTimeInterval                  0.4
#define kDoubleClickTimeInterval                0.5
#define kMFDispatcherKey                        @"MFDispatcherKey"
#define kMFDispatcherEventType                  @"MFDispatcherEventTypeKey"
#define kMFDispatcherParams                     @"MFDispatcherParamsKey"
#define kMFIndexPath                            @"MFIndexPath"

#define kMFVirtualHeadNode                      @"MFVirtualHeadNode"
#define kMFVirtualBodyNode                      @"MFVirtualBodyNode"
#define kMFVirtualFootNode                      @"MFVirtualFootNode"

typedef enum {
    MFSDK_PLUGIN_LUA = 0,
    MFSDK_PLUGIN_HTML,
    MFSDK_PLUGIN_CSS,
}MFPlugInType;

typedef enum {
    MFSDK_SCRIPT_LUA = 0,
    MFSDK_SCRIPT_JS,
}MFSDKScriptType;

typedef enum {
    MFBGImageTypeWhite = 0,
    MFBGImageTypeWhite2 = 1,
    MFBGImageTypeBlue = 2,
    MFBGImageTypeBlue2 = 3,
    MFBGImageTypeBlueWhite = 4,
    
} MFBGImageType;




//以下为Chat相关，到时候移到HiChat上层CTDefine.h

#define kNotificationHiChatBackgroundImageDidUpdate \
                                                @"kNotificationHiChatBackgroundImageDidUpdate"
#define MFSDKImage(imageName)   \
                                                [UIImage imageNamed:[NSString stringWithFormat:@"MFSDK.bundle/%@", imageName]]

//参数
#define L_OPT_USERID                            @"tUserId"
#define L_OPT_USERNAME                          @"tUserName"
#define L_OPT_RETURNID                          @"returnAppId"
#define L_OPT_USERTYPE                          @"tUserType"
#define L_OPT_HIDEMENU                          @"hideMenu"
#define L_OPT_FORCEREQUEST                      @"forceRequest"


typedef enum {
    MFAlignmentTypeLeft = 0,
    MFAlignmentTypeCenter = 1,
    MFAlignmentTypeRight = 2,
    MFAlignmentTypeNone = 3,
} MFAlignmentType;

typedef enum {
    MFLayoutTypeStretch = 0,
    MFLayoutTypeAbsolute = 1,
    MFLayoutTypeNone = 2,
} MFLayoutType;

typedef enum {
    MFCellStatusNone = 0,
    MFCellStatusRuning = 1,
    MFCellStatusFinish = 2,
    MFCellStatusNotSend = 3,
    MFCellStatusFail = 4,
} MFCellStatusType;

typedef enum {
    MFChatMessageTypeOrdinary = 0,
    MFChatMessageTypeReminder = 1,
    MFChatMessageTypeInvalid = 2,
} MFChatMessageType;

#endif
