//
//  interfaces.h
//  Notchification
//
//  Created by Will Smillie on 7/17/18.
//
#import <Preferences/Preferences.h>
#import "IPC.h"

@interface SBApplicationController
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(NSString *)bid;
- (id *)applicationWithDisplayIdentifier:(NSString *)identifier;
@end

@interface SpringBoard
-(void)_relaunchSpringBoardNow;
-(BOOL)isLocked;
-(void)_simulateLockButtonPress;
-(void)_turnScreenOnOnDashBoardWithCompletion:(/*^block*/id)arg1 ;
@end
@interface BBServer : NSObject
-(void)withdrawBulletinID:(id)arg1 ;
-(void)withdrawBulletinRequestsWithRecordID:(id)arg1 forSectionID:(id)arg2;
-(void)_removeBulletins:(id)arg1 forSectionID:(id)arg2 shouldSync:(BOOL)arg3 ;
-(void)_removeBulletin:(id)arg1 shouldSync:(BOOL)arg2;
-(void)_clearBulletinIDs:(id)arg1 forSectionID:(id)arg2 shouldSync:(BOOL)arg3 ;
-(id)_sectionInfoForSectionID:(id)arg1 effective:(BOOL)arg2 ;
-(void)receivedNotification:(id)bulletin;
@end

@interface BBSectionInfoSettings
@property (nonatomic) long long authorizationStatus;
-(id)_authorizationStatusDescription;
-(BOOL)allowsNotifications;
@end

@interface BBBulletinServer
-(void)observer:(id)arg1 removeBulletin:(id)arg2;
-(void)_dismissWithdrawnBannerIfNecessaryFromBulletinIDs:(id)arg1;
@end
@interface BBBulletin : NSObject
@property (assign,nonatomic) BOOL turnsOnDisplay;
@property (copy, nonatomic) NSString* sectionID;
@property (nonatomic,copy) NSString * categoryID;
@property (nonatomic,copy) NSString * recordID;
@property (nonatomic,copy) NSString * bulletinID;
@property (nonatomic,retain) NSDictionary * context;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * subtitle;
@property (nonatomic,copy) NSString * message;
@property (assign,nonatomic) BOOL clearable;
@property (nonatomic,retain) NSDate * date;
@property (nonatomic,retain) NSDate * publicationDate;
@property (nonatomic,retain) NSDate * lastInterruptDate;
-(void)setShowsMessagePreview:(BOOL)arg1 ;
-(NSString *)bulletinID;
-(NSString *)recordID;
-(void)noteFinishedWithBulletinID:(id)arg1 ;
-(id)dismissAction;
-(void)setDefaultAction:(id)arg1 ;
-(id)responseForAction:(id)arg1 ;
@property (nonatomic,copy) NSMutableDictionary *actions;
@end
@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)exitAndRelaunch:(bool)arg1;
@end

@interface PSSplitViewController (Notchification)
- (void)popRecursivelyToRootController;
@end

@interface SBAlertItem : NSObject
@end
@interface SBUserNotificationAlert : SBAlertItem
-(int)token;
- (void)setAlertHeader:(NSString *)header;
- (void)setAlertMessage:(NSString *)msg;
- (void)setDefaultButtonTitle:(NSString *)title;
- (void)setAlternateButtonTitle:(NSString *)title;
@end
@interface SBAlertItemsController : NSObject
+ (id)sharedInstance;
- (void)activateAlertItem:(SBAlertItem *)item;
@end
@interface SBApplication : NSObject
@property(copy) NSString* displayIdentifier;
@property(copy) NSString* bundleIdentifier;
- (id)valueForKey:(id)arg1;
- (NSString *)displayName;
- (int)pid;
- (id)mainScene;
- (NSString *)path;
- (id)mainScreenContextHostManager;
- (void)setDeactivationSetting:(unsigned int)setting value:(id)value;
- (void)setDeactivationSetting:(unsigned int)setting flag:(BOOL)flag;
- (id)bundleIdentifier;
- (id)displayIdentifier;
- (void)notifyResignActiveForReason:(int)reason;
- (void)notifyResumeActiveForReason:(int)reason;
- (void)activate;
- (void)setFlag:(long long)arg1 forActivationSetting:(unsigned int)arg2;
- (BOOL)statusBarHidden;
-(id)_snapshotManifest;
-(id)initWithApplication:(id)arg1 ;
@end

typedef struct SBIconImageInfo {
    CGSize size;
    double scale;
    double continuousCornerRadius;
} SBIconImageInfo;

@interface SBIcon : NSObject
@property (nonatomic, retain) NSString* applicationBundleID;
-(NSString*)displayNameForLocation:(NSInteger)location;
-(UIImage*)generateIconImage:(int)arg1;
-(id)generateIconImageWithInfo:(SBIconImageInfo)arg1 ;
@end
@interface SBApplicationIcon : NSObject
@property (nonatomic, retain) SBApplication* application;
-(id)generateIconImage:(int)arg1 ;
@end
@interface SBIconView : UIView
@property (nonatomic, retain) SBIcon* icon;
@end
@interface SBIconModel : NSObject
-(id)expectedIconForDisplayIdentifier:(NSString*)ident;
@end
@interface SBRootFolderController : NSObject
@property (nonatomic, retain) UIView* contentView;
@end
@interface SBIconController : NSObject
+(id)sharedInstance;
@property (nonatomic, retain) SBIconModel* model;
@property (nonatomic, assign) BOOL isEditing;
-(UIView*)currentRootIconList;
-(UIView*)dockListView;
-(SBRootFolderController*)_rootFolderController;
-(SBRootFolderController*)_currentFolderController;
-(void)clearHighlightedIcon;
-(NSInteger)currentIconListIndex;
-(void)removeIcon:(id)arg1 compactFolder:(BOOL)arg2;
-(id)insertIcon:(id)arg1 intoListView:(id)arg2 iconIndex:(long long)arg3 moveNow:(BOOL)arg4 pop:(BOOL)arg5;
-(id)rootFolder;
-(UIView*)iconListViewAtIndex:(NSInteger)index inFolder:(id)folder createIfNecessary:(BOOL)create;
-(BOOL)scrollToIconListAtIndex:(long long)arg1 animate:(BOOL)arg2;
-(NSArray*)allApplications;
-(BOOL)_canRevealShortcutMenu;
-(void)_revealMenuForIconView:(SBIconView*)icon presentImmediately:(BOOL)immediately;
-(void)_dismissShortcutMenuAnimated:(BOOL)animated completionHandler:(id)completionHandler;
@end
@interface SBBannerController : NSObject
+ (id)sharedInstance;

- (id)_bannerContext;
- (void)_replaceIntervalElapsed;
- (void)_dismissIntervalElapsed;
@end
@interface BBBulletinRequest : BBBulletin
@end
@interface BBAction : NSObject
+ (id)action;
+ (id)actionWithLaunchURL:(id)url;
@end
@interface SBBulletinBannerController : NSObject
+ (id)sharedInstance;
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(NSUInteger)arg3;
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(NSUInteger)arg3 playLightsAndSirens:(BOOL)arg4 withReply:(id)arg5;
@end
@interface SBLockScreenManager
+(id)sharedInstance;
-(BOOL)isLockScreenActive;
-(BOOL)isUILocked;
-(void)_setMesaUnlockingDisabled:(BOOL)arg1 forReason:(id)arg2 ;
-(void)_setMesaAutoUnlockingDisabled:(BOOL)arg1 forReason:(id)arg2 ;
-(void)_setMesaCoordinatorDisabled:(BOOL)arg1 forReason:(id)arg2 ;
-(void)setBiometricAutoUnlockingDisabled:(BOOL)arg1 forReason:(id)arg2;
@end
@interface SBLockScreenViewControllerBase
-(BOOL)isInScreenOffMode;
@end

@interface SBLockStateAggregator : NSObject
+(id)sharedInstance;
-(unsigned long long)lockState;
@end

@interface SBDashBoardIdleTimerProvider : NSObject
@property (getter=isIdleTimerEnabled,nonatomic,readonly) BOOL idleTimerEnabled;
- (void)addDisabledIdleTimerAssertionReason:(id)arg1;
- (void)removeDisabledIdleTimerAssertionReason:(id)arg1;
@end

@interface SBPocketStateMonitor
+(id)sharedInstance;
-(long long)pocketState;
@property (nonatomic,readonly) long long pocketState;               //@synthesize pocketState=_pocketState - In the implementation block
@end

@interface SBBacklightController
+(id)sharedInstance;
-(BOOL)screenIsOn;
-(void)_undimFromSource:(long long)arg1 ;
-(void)turnOnScreenFullyWithBacklightSource:(long long)arg1 ;
@end


@interface SBHomeScreenViewController : UIViewController
@end
