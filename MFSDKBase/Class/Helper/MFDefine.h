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


#define kNotificationDidChangeMediaState        @"kNotificationDidChangeMediaState"
#define DEFAULTICONNAME @"headIcon.png"
#define DEFAULTICON [PKResourceCenter imageNamed:@"headIcon.png"]

//模版id
#define DIALOG_TEMPLATE_MESSAGE @"1"
#define DIALOG_TEMPLATE_SHARE @"1001"
#define DIALOG_TEMPLATE_BANNER @"1002"
#define DIALOG_TEMPLATE_BANNERNOTITLE @"1003"
#define DIALOG_TEMPLATE_UNKNOW @"10000"
//访问KEY PKey_UI
#define KEY_HEADICON @"HeadIcon"
#define KEY_DATASOURCE @"sources"
#define KEY_HEADPORTRAIT @"headportrait"
#define KEY_NODE_UI @"UI"
#define KEY_NODE_DATA @"Data"
#define KEY_NODE_VIEWS @"Views"
#define KEY_NODE_PROPERTIES @"Properties"
#define KEY_WIDGET @"widget"
#define KEY_WIDGET_NODE @"widgetNode"
#define KEY_WIDGET_STYLE @"widgetStyle"
#define KEY_WIDGET_DATA_BINDING @"widgetDataBinding"
#define KEY_WIDGET_INFO @"widgetInfo"
#define KEY_PROPERTIES_SYMBOL @"symbol"
#define KEY_WIDGET_LEFT @"left"
#define KEY_WIDGET_TOP @"top"
#define KEY_WIDGET_WIDTH @"width"
#define KEY_WIDGET_HEIGHT @"height"
#define KEY_WIDGET_ALIGNMENTTYPE @"alignmentType"
#define KEY_WIDGET_SIZE @"widgetSize"
#define KEY_WIDGET_TYPE_LABEL @"label"
#define KEY_WIDGET_TYPE_SLIDELABEL @"slidelabel"
#define KEY_WIDGET_TYPE_IMAGE @"image"
#define KEY_WIDGET_TYPE_EMOJI @"emoji"
#define KEY_WIDGET_TYPE_VOICE @"voice"
#define KEY_WIDGET_TYPE_MESSAGE @"message"
#define KEY_WIDGET_TYPE_MSGTYPE @"msgType"

//关键字
#define KEYWORD_SEED @"seed"
#define KEYWORD_MSGID @"msgID"
#define KEYWORD_PAGE @"Page"
#define KEYWORD_ID @"id"
#define KEYWORD_TEMPLATE_ID @"templateId"
#define KEYWORD_DS_DATA @"data"
#define KEYWORD_AUTOLAYOUT @"autoLayout"
#define KEYWORD_FRAME @"frame"
#define KEYWORD_TYPE @"type"
#define KEYWORD_FONTSIZE @"fontSize"
#define KEYWORD_FONTBOLD @"fontBold"
#define KEYWORD_DATASOURCEKEY @"dsKey"
#define KEYWORD_NUMBEROFLINES @"numberOfLines"
#define KEYWORD_TEXTALIGNMENT @"textAlignment"
#define KEYWORD_TEXTCOLOR @"textColor"
#define KEYWORD_HIGHLIGHTTEXTCOLOR @"highLightTextColor"
#define KEYWORD_BACKGROUNDCOLOR @"backgroundColor"
#define KEYWORD_TOUCHENABLED @"touchEnabled"

//参数
#define L_OPT_USERID        @"tUserId"
#define L_OPT_USERNAME      @"tUserName"
#define L_OPT_RETURNID      @"returnAppId"
#define L_OPT_USERTYPE      @"tUserType"
#define L_OPT_HIDEMENU      @"hideMenu"
#define L_OPT_FORCEREQUEST      @"forceRequest"

#define STANDARD_WIDTH 320
#define IMAGEWIDTH 160
#define IMAGEHEIGHT 160
#define space 10
#define space_arrow 12
#define compensationPoint 0
#define defaultCellHeight 90
#define PAGESIZE 10
#define kDeviceWidth                [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight               [UIScreen mainScreen].bounds.size.height
#define TIMEOUT 5*60
#define DOUBLE_TAP_DELAY 0.3

#endif
