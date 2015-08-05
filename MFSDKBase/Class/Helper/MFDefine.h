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

#define MF_DEFAULTICONNAME                         @"headIcon.png"
#define MF_DEFAULTICON                             [MFResourceCenter imageNamed:MF_DEFAULTICONNAME]


//模版id
#define MF_DIALOG_TEMPLATE_UNKNOW                  @"tid-10000"

//访问KEY PKey_UI
#define MF_KEY_DATASOURCE                          @"sources"
#define MF_KEY_WIDGET                              @"widget"
#define MF_KEY_WIDGET_NODE                         @"widgetNode"
#define MF_KEY_WIDGET_STYLE                        @"widgetStyle"
#define MF_KEY_WIDGET_DATA_BINDING                 @"widgetDataBinding"
#define MF_KEY_WIDGET_EVENTS                       @"widgetEvents"
#define MF_KEY_WIDGET_INFO                         @"widgetInfo"

#define MF_KEY_WIDGET_ALIGNMENTTYPE                @"alignmentType"
#define MF_KEY_WIDGET_LEFT                         @"left"
#define MF_KEY_WIDGET_TOP                          @"top"
#define MF_KEY_WIDGET_WIDTH                        @"width"
#define MF_KEY_WIDGET_MAX_WIDTH                    @"max-width"
#define MF_KEY_WIDGET_MIN_WIDTH                    @"min-width"
#define MF_KEY_WIDGET_HEIGHT                       @"height"
#define MF_KEY_WIDGET_MAX_HEIGHT                   @"max-height"
#define MF_KEY_WIDGET_MIN_HEIGHT                   @"min-height"
#define MF_KEY_WIDGET_SIZE                         @"widgetSize"
#define MF_KEYWORD_FRAME                           @"frame"

//关键字
#define MF_KEYWORD_SEED                            @"seed"
#define MF_KEYWORD_ID                              @"id"
#define MF_KEYWORD_DS_DATA                         @"data"
#define MF_KEYWORD_DATASOURCEKEY                   @"dsKey"
#define MF_KEYWORD_LINK                            @"link"
#define MF_KEYWORD_NUMBEROFLINES                   @"numberOfLines"


#define MF_STANDARD_WIDTH                          320
#define MF_IMAGEWIDTH                              120
#define MF_IMAGEHEIGHT                             120
#define kMFDeviceWidth                             [UIScreen mainScreen].bounds.size.width
#define kMFDeviceHeight                            [UIScreen mainScreen].bounds.size.height

#define MFSectionTimeHeaderHeight                  0
#define MFSectionCellHeight                        20
#define MFSectionHeaderHeight                      15
#define MFSectionFooterHeight                      15
#define MFCellHeaderFontSize                       12
#define MFCellFooterFontSize                       13
#define MFTipsHeightSpace                          4
#define MFTipsWidthSpace                           4

#define kMFOnLongPressEvent                        @"longpress"
#define kMFOnClickEvent                            @"onclick"
#define kMFOnDbClickEvent                          @"ondbclick"
#define kMFOnSwipeEvent                            @"onswipe"
#define kMFOnLoadEvent                             @"onload"
#define kMFOnUnloadEvent                           @"onunload"
#define kMFOnPageShowEvent                         @"onpageshow"
#define kMFOnPageHideEvent                         @"onpagehide"

#define kMFLongPressTimeInterval                   0.4
#define kMFDoubleClickTimeInterval                 0.5
#define kMFDispatcherKey                           @"MFDispatcherKey"
#define kMFDispatcherEventType                     @"MFDispatcherEventTypeKey"
#define kMFDispatcherParams                        @"MFDispatcherParamsKey"
#define kMFIndexPath                               @"MFIndexPath"

#define kMFVirtualHeadNode                         @"MFVirtualHeadNode"
#define kMFVirtualBodyNode                         @"MFVirtualBodyNode"
#define kMFVirtualFootNode                         @"MFVirtualFootNode"

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
