#line 1 "/Users/willsmillie/Desktop/Documents/Development/iOS/Jailbreak/Notchification/Notchification/Notchification.xm"
#import "EWindow.h"
#import <Enclave.h>
#import "interfaces.h"


static EWindow *window;
static NSDictionary *settings;
static Enclave *enclave;
static SpringBoard *springboard;

static SBUserNotificationAlert *startupAlert;
static BOOL hasUnlocked = NO;

#define tweakName @"Notchification"
#define changelog [NSString stringWithFormat:@"/Library/Application Support/%@/changelog.plist", tweakName]



#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBBacklightController; @class SBLiftToWakeManager; @class SpringBoard; @class SBAlertItemsController; @class DNDState; @class SBHomeScreenViewController; @class SBDashBoardIdleTimerProvider; @class SBLockScreenManager; @class NCNotificationListCell; @class BBServer; @class NCNotificationOptions; @class SBLockHardwareButton; @class SBUserNotificationAlert; @class SBHomeHardwareButton; 
static void (*_logos_orig$_ungrouped$SBHomeScreenViewController$viewDidAppear$)(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$SBHomeScreenViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UIApplication *); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UIApplication *); static void (*_logos_orig$_ungrouped$SpringBoard$_simulateHomeButtonPress)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SpringBoard$_simulateHomeButtonPress(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SpringBoard$_simulateHomeButtonPressWithCompletion$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$_simulateHomeButtonPressWithCompletion$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SpringBoard$_handleMenuButtonEvent)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SpringBoard$_handleMenuButtonEvent(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SBHomeHardwareButton$singlePressUp$)(_LOGOS_SELF_TYPE_NORMAL SBHomeHardwareButton* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SBHomeHardwareButton$singlePressUp$(_LOGOS_SELF_TYPE_NORMAL SBHomeHardwareButton* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SBLockHardwareButton$singlePress$)(_LOGOS_SELF_TYPE_NORMAL SBLockHardwareButton* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SBLockHardwareButton$singlePress$(_LOGOS_SELF_TYPE_NORMAL SBLockHardwareButton* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SBLockScreenManager$_finishUIUnlockFromSource$withOptions$)(_LOGOS_SELF_TYPE_NORMAL SBLockScreenManager* _LOGOS_SELF_CONST, SEL, int, id); static void _logos_method$_ungrouped$SBLockScreenManager$_finishUIUnlockFromSource$withOptions$(_LOGOS_SELF_TYPE_NORMAL SBLockScreenManager* _LOGOS_SELF_CONST, SEL, int, id); static void (*_logos_orig$_ungrouped$SBLockScreenManager$_setUILocked$)(_LOGOS_SELF_TYPE_NORMAL SBLockScreenManager* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$SBLockScreenManager$_setUILocked$(_LOGOS_SELF_TYPE_NORMAL SBLockScreenManager* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$_ungrouped$SBLockScreenManager$_lockScreenDimmed$)(_LOGOS_SELF_TYPE_NORMAL SBLockScreenManager* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SBLockScreenManager$_lockScreenDimmed$(_LOGOS_SELF_TYPE_NORMAL SBLockScreenManager* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SBLiftToWakeManager$liftToWakeController$didObserveTransition$)(_LOGOS_SELF_TYPE_NORMAL SBLiftToWakeManager* _LOGOS_SELF_CONST, SEL, id, long long); static void _logos_method$_ungrouped$SBLiftToWakeManager$liftToWakeController$didObserveTransition$(_LOGOS_SELF_TYPE_NORMAL SBLiftToWakeManager* _LOGOS_SELF_CONST, SEL, id, long long); static void (*_logos_orig$_ungrouped$SBLiftToWakeManager$liftToWakeController$didObserveTransition$deviceOrientation$)(_LOGOS_SELF_TYPE_NORMAL SBLiftToWakeManager* _LOGOS_SELF_CONST, SEL, id, long long, long long); static void _logos_method$_ungrouped$SBLiftToWakeManager$liftToWakeController$didObserveTransition$deviceOrientation$(_LOGOS_SELF_TYPE_NORMAL SBLiftToWakeManager* _LOGOS_SELF_CONST, SEL, id, long long, long long); static BOOL (*_logos_orig$_ungrouped$SBLiftToWakeManager$handleEvent$)(_LOGOS_SELF_TYPE_NORMAL SBLiftToWakeManager* _LOGOS_SELF_CONST, SEL, id); static BOOL _logos_method$_ungrouped$SBLiftToWakeManager$handleEvent$(_LOGOS_SELF_TYPE_NORMAL SBLiftToWakeManager* _LOGOS_SELF_CONST, SEL, id); static BOOL (*_logos_orig$_ungrouped$DNDState$isActive)(_LOGOS_SELF_TYPE_NORMAL DNDState* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$_ungrouped$DNDState$isActive(_LOGOS_SELF_TYPE_NORMAL DNDState* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$BBServer$publishBulletin$destinations$alwaysToLockScreen$)(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST, SEL, BBBulletin *, unsigned int, BOOL); static void _logos_method$_ungrouped$BBServer$publishBulletin$destinations$alwaysToLockScreen$(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST, SEL, BBBulletin *, unsigned int, BOOL); static void (*_logos_orig$_ungrouped$BBServer$publishBulletin$destinations$)(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST, SEL, BBBulletin *, unsigned long long); static void _logos_method$_ungrouped$BBServer$publishBulletin$destinations$(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST, SEL, BBBulletin *, unsigned long long); static void _logos_method$_ungrouped$BBServer$receivedNotification$(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST, SEL, BBBulletin *); static BOOL (*_logos_orig$_ungrouped$NCNotificationOptions$canTurnOnDisplay)(_LOGOS_SELF_TYPE_NORMAL NCNotificationOptions* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$_ungrouped$NCNotificationOptions$canTurnOnDisplay(_LOGOS_SELF_TYPE_NORMAL NCNotificationOptions* _LOGOS_SELF_CONST, SEL); static SBDashBoardIdleTimerProvider* (*_logos_orig$_ungrouped$SBDashBoardIdleTimerProvider$initWithDelegate$)(_LOGOS_SELF_TYPE_INIT SBDashBoardIdleTimerProvider*, SEL, id) _LOGOS_RETURN_RETAINED; static SBDashBoardIdleTimerProvider* _logos_method$_ungrouped$SBDashBoardIdleTimerProvider$initWithDelegate$(_LOGOS_SELF_TYPE_INIT SBDashBoardIdleTimerProvider*, SEL, id) _LOGOS_RETURN_RETAINED; static void _logos_method$_ungrouped$SBDashBoardIdleTimerProvider$disableIdleTimer(_LOGOS_SELF_TYPE_NORMAL SBDashBoardIdleTimerProvider* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBDashBoardIdleTimerProvider$enableIdleTimer(_LOGOS_SELF_TYPE_NORMAL SBDashBoardIdleTimerProvider* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$NCNotificationListCell$cellClearButtonPressed$)(_LOGOS_SELF_TYPE_NORMAL NCNotificationListCell* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$NCNotificationListCell$cellClearButtonPressed$(_LOGOS_SELF_TYPE_NORMAL NCNotificationListCell* _LOGOS_SELF_CONST, SEL, id); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBAlertItemsController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBAlertItemsController"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBUserNotificationAlert(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBUserNotificationAlert"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBBacklightController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBBacklightController"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBLockScreenManager(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBLockScreenManager"); } return _klass; }
#line 18 "/Users/willsmillie/Desktop/Documents/Development/iOS/Jailbreak/Notchification/Notchification/Notchification.xm"

static void _logos_method$_ungrouped$SBHomeScreenViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL SBHomeScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL arg1){
    _logos_orig$_ungrouped$SBHomeScreenViewController$viewDidAppear$(self, _cmd, arg1);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        enclave.whatsNewViewController.changelogPath = changelog;
        enclave.whatsNewViewController.title = tweakName;

        if (![enclave.whatsNewViewController hasShowLatestVersion]) {
            UIViewController *vc = self;
            while (vc.presentedViewController) {vc = vc.presentedViewController;}
            [vc presentViewController:enclave.whatsNewViewController animated:YES completion:nil];
        }
    });
}





static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIApplication * arg1){
    _logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, arg1);
    
    springboard = self;
        
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[EWindow settingsPath]]){
        [@{} writeToFile:[EWindow settingsPath] atomically:NO];
        NSMutableDictionary *settings = [EWindow settings];
        [settings setObject:[NSNumber numberWithBool:TRUE] forKey:@"hasBeenLaunchedBefore"];
        [settings setObject:[NSNumber numberWithBool:TRUE] forKey:@"lsenabled"];
        [settings setObject:[NSNumber numberWithBool:TRUE] forKey:@"lsblackout"];
        [settings setObject:[NSNumber numberWithBool:TRUE] forKey:@"sbenabled"];
        [settings setObject:[NSNumber numberWithBool:TRUE] forKey:@"showNotificationAfterAnimation"];
        [settings setObject:@"[responsive] particles" forKey:@"animation"];
        [settings writeToFile:[EWindow settingsPath] atomically:YES];
    }
        
    
    enclave = [[Enclave alloc] initWithAPIKey:@"d8ef62a890f8a8c898315f9ec307f2c7398a9c7b" andSecretKey:@"e786b2d64ac2129d2f413284743dffcd06b454ec"];
    settings = [EWindow settings];
    
    BOOL alwaysOn = [settings[@"alwayson"] boolValue];

    [enclave isAuthenticated:^(NSError *error, BOOL validAuth){
        if (validAuth){
            NSLog(@"[Notch] Valid auth!");
            window = [EWindow sharedWindow];        
            if (alwaysOn){
                [window showWithBlackout:NO andBundleId:@"com.c1der.notchification.alwayson" isUnlocked:YES];
            }

        }else{
            NSLog(@"[Notch] Not Authenticated: %@", error);
            if (!startupAlert){
                if (error.code == 1){
                    startupAlert = [[_logos_static_class_lookup$SBUserNotificationAlert() alloc] init];
                    [startupAlert setAlertHeader:@"Notchification"];
                    [startupAlert setAlertMessage:@"Please activate in Settings > Notchification"];
                    [startupAlert setDefaultButtonTitle:@"Ok!"];
                    [(SBAlertItemsController *)[_logos_static_class_lookup$SBAlertItemsController() sharedInstance] activateAlertItem:startupAlert];
                }else{
                    startupAlert = [[_logos_static_class_lookup$SBUserNotificationAlert() alloc] init];
                    [startupAlert setAlertHeader:@"Notchification"];
                    [startupAlert setAlertMessage:error.localizedDescription];
                    [startupAlert setDefaultButtonTitle:@"Ok!"];
                    [(SBAlertItemsController *)[_logos_static_class_lookup$SBAlertItemsController() sharedInstance] activateAlertItem:startupAlert];
                }
            }
        }
    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        hasUnlocked = YES;
    });
}





static void _logos_method$_ungrouped$SpringBoard$_simulateHomeButtonPress(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    if (window.isBlackoutShowing) {
        [window endAnimation:YES clearBlackout:YES animated:YES];
    }else{
        _logos_orig$_ungrouped$SpringBoard$_simulateHomeButtonPress(self, _cmd);
    }
}
static void _logos_method$_ungrouped$SpringBoard$_simulateHomeButtonPressWithCompletion$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
    if (window.isBlackoutShowing) {
        [window endAnimation:YES clearBlackout:YES animated:YES];
    }else{
        _logos_orig$_ungrouped$SpringBoard$_simulateHomeButtonPressWithCompletion$(self, _cmd, arg1);
    }
}
static void _logos_method$_ungrouped$SpringBoard$_handleMenuButtonEvent(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    if (window.isBlackoutShowing) {
        [window endAnimation:YES clearBlackout:YES animated:YES];
    }else{
        _logos_orig$_ungrouped$SpringBoard$_handleMenuButtonEvent(self, _cmd);
    }
}


static void _logos_method$_ungrouped$SBHomeHardwareButton$singlePressUp$(_LOGOS_SELF_TYPE_NORMAL SBHomeHardwareButton* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){
    if (window.isBlackoutShowing) {
        [window endAnimation:YES clearBlackout:YES animated:YES];
    }else{
        _logos_orig$_ungrouped$SBHomeHardwareButton$singlePressUp$(self, _cmd, arg1);
    }
}


static void _logos_method$_ungrouped$SBLockHardwareButton$singlePress$(_LOGOS_SELF_TYPE_NORMAL SBLockHardwareButton* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){
    if (window.isBlackoutShowing) {
        [window endAnimation:YES clearBlackout:YES animated:YES];
    }else{
        _logos_orig$_ungrouped$SBLockHardwareButton$singlePress$(self, _cmd, arg1);
    }
}





static void _logos_method$_ungrouped$SBLockScreenManager$_finishUIUnlockFromSource$withOptions$(_LOGOS_SELF_TYPE_NORMAL SBLockScreenManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg1, id arg2){
    if (window.isShowing)
        [window endAnimation:YES clearBlackout:YES animated:YES];
    _logos_orig$_ungrouped$SBLockScreenManager$_finishUIUnlockFromSource$withOptions$(self, _cmd, arg1, arg2);
}
static void _logos_method$_ungrouped$SBLockScreenManager$_setUILocked$(_LOGOS_SELF_TYPE_NORMAL SBLockScreenManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL arg1){
    _logos_orig$_ungrouped$SBLockScreenManager$_setUILocked$(self, _cmd, arg1);
    if (arg1){
        if (window.isShowing | window.isBlackoutShowing)
            [window endAnimation:YES clearBlackout:YES animated:NO];
    }
}
static void _logos_method$_ungrouped$SBLockScreenManager$_lockScreenDimmed$(_LOGOS_SELF_TYPE_NORMAL SBLockScreenManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){
    _logos_orig$_ungrouped$SBLockScreenManager$_lockScreenDimmed$(self, _cmd, arg1);
    
    if (window.isShowing | window.isBlackoutShowing)
        [window endAnimation:YES clearBlackout:YES animated:NO];
}





static void _logos_method$_ungrouped$SBLiftToWakeManager$liftToWakeController$didObserveTransition$(_LOGOS_SELF_TYPE_NORMAL SBLiftToWakeManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, long long arg2) {
    _logos_orig$_ungrouped$SBLiftToWakeManager$liftToWakeController$didObserveTransition$(self, _cmd, arg1, arg2);
    if (window.isBlackoutShowing && arg2 == 2){
        [window endAnimation:YES clearBlackout:YES animated:YES];
    }
}


static void _logos_method$_ungrouped$SBLiftToWakeManager$liftToWakeController$didObserveTransition$deviceOrientation$(_LOGOS_SELF_TYPE_NORMAL SBLiftToWakeManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, long long arg2, long long arg3){
    _logos_orig$_ungrouped$SBLiftToWakeManager$liftToWakeController$didObserveTransition$deviceOrientation$(self, _cmd, arg1, arg2, arg3);
    if (window.isBlackoutShowing  && arg2 == 2){
        [window endAnimation:YES clearBlackout:YES animated:YES];
    }
}


static BOOL _logos_method$_ungrouped$SBLiftToWakeManager$handleEvent$(_LOGOS_SELF_TYPE_NORMAL SBLiftToWakeManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){
    BOOL o = _logos_orig$_ungrouped$SBLiftToWakeManager$handleEvent$(self, _cmd, arg1);
    
    if (window.isBlackoutShowing){
        return YES;
    }else{
        return o;
    }
}






BOOL DNDEnabled = NO;


static BOOL _logos_method$_ungrouped$DNDState$isActive(_LOGOS_SELF_TYPE_NORMAL DNDState* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    bool o = _logos_orig$_ungrouped$DNDState$isActive(self, _cmd);
    DNDEnabled = o;
    return o;
}




static BOOL isRealScreenOn;



static void _logos_method$_ungrouped$BBServer$publishBulletin$destinations$alwaysToLockScreen$(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BBBulletin * bulletin, unsigned int arg2, BOOL arg3){
    isRealScreenOn = [[_logos_static_class_lookup$SBBacklightController() sharedInstance] screenIsOn];
    _logos_orig$_ungrouped$BBServer$publishBulletin$destinations$alwaysToLockScreen$(self, _cmd, bulletin, arg2, arg3);
    if (arg2){
        [self receivedNotification:bulletin];
    }
}


static void _logos_method$_ungrouped$BBServer$publishBulletin$destinations$(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BBBulletin * bulletin, unsigned long long arg2){
    isRealScreenOn = [[_logos_static_class_lookup$SBBacklightController() sharedInstance] screenIsOn];
    _logos_orig$_ungrouped$BBServer$publishBulletin$destinations$(self, _cmd, bulletin, arg2);
    if (arg2){
        [self receivedNotification:bulletin];
    }
}



static void _logos_method$_ungrouped$BBServer$receivedNotification$(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BBBulletin * bulletin){
    if (!hasUnlocked){
        return;
    }

    static BOOL isScreenOn;

    if (!isRealScreenOn | window.isBlackoutShowing){
        isScreenOn = NO;
    }else{
        isScreenOn = YES;
    }
    
    BBSectionInfoSettings *notificationSettings = [self _sectionInfoForSectionID:bulletin.sectionID effective:true];

    __block BOOL show = NO;
    if (![bulletin.sectionID isKindOfClass:[NSNull class]] && notificationSettings.allowsNotifications) {
        if (bulletin.sectionID.length > 0){
            if ((![bulletin.title isKindOfClass:[NSNull class]] | ![bulletin.message isKindOfClass:[NSNull class]])) {
                if ((bulletin.title.length > 0 | bulletin.message.length > 0)){
                    show = YES;
                }
            }
        }
    }

    settings = [EWindow settings];

    if ([settings[@"alwayson"] boolValue]){
        return;
    }

    BOOL SBEnabled = [settings[@"sbenabled"] boolValue];
    BOOL LSEnabled = [settings[@"lsenabled"] boolValue];
    BOOL blackout = [settings[@"lsblackout"] boolValue];
    BOOL showInDND = [settings[@"showInDND"] boolValue];



    if (show){
        
        if (([(SpringBoard*)[UIApplication sharedApplication] isLocked] && LSEnabled)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (showInDND && !isScreenOn && DNDEnabled){
                    [springboard _turnScreenOnOnDashBoardWithCompletion:nil];
                }
                [window showWithBlackout:isScreenOn?NO:blackout andBundleId:bulletin.sectionID isUnlocked:NO];
            });
        }

        
        if ((![(SpringBoard*)[UIApplication sharedApplication] isLocked] && SBEnabled)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [window showWithBlackout:NO andBundleId:bulletin.sectionID isUnlocked:YES];
            });
        }
    }
}






static BOOL _logos_method$_ungrouped$NCNotificationOptions$canTurnOnDisplay(_LOGOS_SELF_TYPE_NORMAL NCNotificationOptions* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    if ([[EWindow settings][@"disableWatchFix"] boolValue]){
        return _logos_orig$_ungrouped$NCNotificationOptions$canTurnOnDisplay(self, _cmd);
    }else{
        return true;
    }
}






static SBDashBoardIdleTimerProvider* _logos_method$_ungrouped$SBDashBoardIdleTimerProvider$initWithDelegate$(_LOGOS_SELF_TYPE_INIT SBDashBoardIdleTimerProvider* __unused self, SEL __unused _cmd, id arg1) _LOGOS_RETURN_RETAINED {
    _logos_orig$_ungrouped$SBDashBoardIdleTimerProvider$initWithDelegate$(self, _cmd, arg1);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableIdleTimer) name:@"notchificationBegan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableIdleTimer) name:@"notchificationFinished" object:nil];
    return self;
}

 static void _logos_method$_ungrouped$SBDashBoardIdleTimerProvider$disableIdleTimer(_LOGOS_SELF_TYPE_NORMAL SBDashBoardIdleTimerProvider* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    [self addDisabledIdleTimerAssertionReason:@"Notchification"];
    if (window.isBlackoutShowing){
        [[_logos_static_class_lookup$SBLockScreenManager() sharedInstance] setBiometricAutoUnlockingDisabled:true forReason:@"Notchification"];
    }
}

 static void _logos_method$_ungrouped$SBDashBoardIdleTimerProvider$enableIdleTimer(_LOGOS_SELF_TYPE_NORMAL SBDashBoardIdleTimerProvider* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    [self removeDisabledIdleTimerAssertionReason:@"Notchification"];
    [[_logos_static_class_lookup$SBLockScreenManager() sharedInstance] setBiometricAutoUnlockingDisabled:false forReason:@"Notchification"];
}



static void _logos_method$_ungrouped$NCNotificationListCell$cellClearButtonPressed$(_LOGOS_SELF_TYPE_NORMAL NCNotificationListCell* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {    
    _logos_orig$_ungrouped$NCNotificationListCell$cellClearButtonPressed$(self, _cmd, arg1);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notchificationFinished" object:self];
    [window endAnimation:YES clearBlackout:YES animated:NO];
}



static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBHomeScreenViewController = objc_getClass("SBHomeScreenViewController"); MSHookMessageEx(_logos_class$_ungrouped$SBHomeScreenViewController, @selector(viewDidAppear:), (IMP)&_logos_method$_ungrouped$SBHomeScreenViewController$viewDidAppear$, (IMP*)&_logos_orig$_ungrouped$SBHomeScreenViewController$viewDidAppear$);Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(_simulateHomeButtonPress), (IMP)&_logos_method$_ungrouped$SpringBoard$_simulateHomeButtonPress, (IMP*)&_logos_orig$_ungrouped$SpringBoard$_simulateHomeButtonPress);MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(_simulateHomeButtonPressWithCompletion:), (IMP)&_logos_method$_ungrouped$SpringBoard$_simulateHomeButtonPressWithCompletion$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$_simulateHomeButtonPressWithCompletion$);MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(_handleMenuButtonEvent), (IMP)&_logos_method$_ungrouped$SpringBoard$_handleMenuButtonEvent, (IMP*)&_logos_orig$_ungrouped$SpringBoard$_handleMenuButtonEvent);Class _logos_class$_ungrouped$SBHomeHardwareButton = objc_getClass("SBHomeHardwareButton"); MSHookMessageEx(_logos_class$_ungrouped$SBHomeHardwareButton, @selector(singlePressUp:), (IMP)&_logos_method$_ungrouped$SBHomeHardwareButton$singlePressUp$, (IMP*)&_logos_orig$_ungrouped$SBHomeHardwareButton$singlePressUp$);Class _logos_class$_ungrouped$SBLockHardwareButton = objc_getClass("SBLockHardwareButton"); MSHookMessageEx(_logos_class$_ungrouped$SBLockHardwareButton, @selector(singlePress:), (IMP)&_logos_method$_ungrouped$SBLockHardwareButton$singlePress$, (IMP*)&_logos_orig$_ungrouped$SBLockHardwareButton$singlePress$);Class _logos_class$_ungrouped$SBLockScreenManager = objc_getClass("SBLockScreenManager"); MSHookMessageEx(_logos_class$_ungrouped$SBLockScreenManager, @selector(_finishUIUnlockFromSource:withOptions:), (IMP)&_logos_method$_ungrouped$SBLockScreenManager$_finishUIUnlockFromSource$withOptions$, (IMP*)&_logos_orig$_ungrouped$SBLockScreenManager$_finishUIUnlockFromSource$withOptions$);MSHookMessageEx(_logos_class$_ungrouped$SBLockScreenManager, @selector(_setUILocked:), (IMP)&_logos_method$_ungrouped$SBLockScreenManager$_setUILocked$, (IMP*)&_logos_orig$_ungrouped$SBLockScreenManager$_setUILocked$);MSHookMessageEx(_logos_class$_ungrouped$SBLockScreenManager, @selector(_lockScreenDimmed:), (IMP)&_logos_method$_ungrouped$SBLockScreenManager$_lockScreenDimmed$, (IMP*)&_logos_orig$_ungrouped$SBLockScreenManager$_lockScreenDimmed$);Class _logos_class$_ungrouped$SBLiftToWakeManager = objc_getClass("SBLiftToWakeManager"); MSHookMessageEx(_logos_class$_ungrouped$SBLiftToWakeManager, @selector(liftToWakeController:didObserveTransition:), (IMP)&_logos_method$_ungrouped$SBLiftToWakeManager$liftToWakeController$didObserveTransition$, (IMP*)&_logos_orig$_ungrouped$SBLiftToWakeManager$liftToWakeController$didObserveTransition$);MSHookMessageEx(_logos_class$_ungrouped$SBLiftToWakeManager, @selector(liftToWakeController:didObserveTransition:deviceOrientation:), (IMP)&_logos_method$_ungrouped$SBLiftToWakeManager$liftToWakeController$didObserveTransition$deviceOrientation$, (IMP*)&_logos_orig$_ungrouped$SBLiftToWakeManager$liftToWakeController$didObserveTransition$deviceOrientation$);MSHookMessageEx(_logos_class$_ungrouped$SBLiftToWakeManager, @selector(handleEvent:), (IMP)&_logos_method$_ungrouped$SBLiftToWakeManager$handleEvent$, (IMP*)&_logos_orig$_ungrouped$SBLiftToWakeManager$handleEvent$);Class _logos_class$_ungrouped$DNDState = objc_getClass("DNDState"); MSHookMessageEx(_logos_class$_ungrouped$DNDState, @selector(isActive), (IMP)&_logos_method$_ungrouped$DNDState$isActive, (IMP*)&_logos_orig$_ungrouped$DNDState$isActive);Class _logos_class$_ungrouped$BBServer = objc_getClass("BBServer"); MSHookMessageEx(_logos_class$_ungrouped$BBServer, @selector(publishBulletin:destinations:alwaysToLockScreen:), (IMP)&_logos_method$_ungrouped$BBServer$publishBulletin$destinations$alwaysToLockScreen$, (IMP*)&_logos_orig$_ungrouped$BBServer$publishBulletin$destinations$alwaysToLockScreen$);MSHookMessageEx(_logos_class$_ungrouped$BBServer, @selector(publishBulletin:destinations:), (IMP)&_logos_method$_ungrouped$BBServer$publishBulletin$destinations$, (IMP*)&_logos_orig$_ungrouped$BBServer$publishBulletin$destinations$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(BBBulletin *), strlen(@encode(BBBulletin *))); i += strlen(@encode(BBBulletin *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$BBServer, @selector(receivedNotification:), (IMP)&_logos_method$_ungrouped$BBServer$receivedNotification$, _typeEncoding); }Class _logos_class$_ungrouped$NCNotificationOptions = objc_getClass("NCNotificationOptions"); MSHookMessageEx(_logos_class$_ungrouped$NCNotificationOptions, @selector(canTurnOnDisplay), (IMP)&_logos_method$_ungrouped$NCNotificationOptions$canTurnOnDisplay, (IMP*)&_logos_orig$_ungrouped$NCNotificationOptions$canTurnOnDisplay);Class _logos_class$_ungrouped$SBDashBoardIdleTimerProvider = objc_getClass("SBDashBoardIdleTimerProvider"); MSHookMessageEx(_logos_class$_ungrouped$SBDashBoardIdleTimerProvider, @selector(initWithDelegate:), (IMP)&_logos_method$_ungrouped$SBDashBoardIdleTimerProvider$initWithDelegate$, (IMP*)&_logos_orig$_ungrouped$SBDashBoardIdleTimerProvider$initWithDelegate$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBDashBoardIdleTimerProvider, @selector(disableIdleTimer), (IMP)&_logos_method$_ungrouped$SBDashBoardIdleTimerProvider$disableIdleTimer, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBDashBoardIdleTimerProvider, @selector(enableIdleTimer), (IMP)&_logos_method$_ungrouped$SBDashBoardIdleTimerProvider$enableIdleTimer, _typeEncoding); }Class _logos_class$_ungrouped$NCNotificationListCell = objc_getClass("NCNotificationListCell"); MSHookMessageEx(_logos_class$_ungrouped$NCNotificationListCell, @selector(cellClearButtonPressed:), (IMP)&_logos_method$_ungrouped$NCNotificationListCell$cellClearButtonPressed$, (IMP*)&_logos_orig$_ungrouped$NCNotificationListCell$cellClearButtonPressed$);} }
#line 340 "/Users/willsmillie/Desktop/Documents/Development/iOS/Jailbreak/Notchification/Notchification/Notchification.xm"
