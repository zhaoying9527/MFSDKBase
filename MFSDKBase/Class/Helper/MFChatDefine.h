//
//  MFChatDefine.h

#ifndef MFChatDefine_MFChatDefine_h
#define MFChatDefine_MFChatDefine_h

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

#define sectionTimeHeaderHeight 0
#define sectionCellHeight 25
#define sectionHeaderHeight     15
#define sectionFooterHeight     15
#define tipsspace 4
#define cellHeaderFontSize 12
#define cellFooterFontSize 13
//参数
#define L_OPT_USERID        @"tUserId"
#define L_OPT_RETURNID      @"returnAppId"
#define L_OPT_USERTYPE      @"tUserType"
#define L_OPT_HIDEMENU      @"hideMenu"
#define L_OPT_FORCEREQUEST  @"forceRequest"

#endif