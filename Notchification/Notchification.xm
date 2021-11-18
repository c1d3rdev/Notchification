#import "EWindow.h"
#import "interfaces.h"


static EWindow *window;
static NSDictionary *settings;
static SpringBoard *springboard;

static SBUserNotificationAlert *startupAlert;
static BOOL hasUnlocked = NO;

#define tweakName @"Notchification"
#define changelog [NSString stringWithFormat:@"/Library/Application Support/%@/changelog.plist", tweakName]


%hook SBHomeScreenViewController
-(void)viewDidAppear:(BOOL)arg1{
    %orig;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//
//        enclave.whatsNewViewController.changelogPath = changelog;
//        enclave.whatsNewViewController.title = tweakName;
//
//        if (![enclave.whatsNewViewController hasShowLatestVersion]) {
//            UIViewController *vc = self;
//            while (vc.presentedViewController) {vc = vc.presentedViewController;}
//            [vc presentViewController:enclave.whatsNewViewController animated:YES completion:nil];
//        }
//    });
}
%end



%hook SpringBoard
- (void)applicationDidFinishLaunching:(UIApplication *)arg1{
    %orig();
    
    springboard = self;
        
    //Default Settings
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
        
    settings = [EWindow settings];
    
    BOOL alwaysOn = [settings[@"alwayson"] boolValue];

    window = [EWindow sharedWindow];
    if (alwaysOn){
        [window showWithBlackout:NO andBundleId:@"com.c1der.notchification.alwayson" isUnlocked:YES];
    }

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        hasUnlocked = YES;
    });
}




//Home Button Methods
-(void)_simulateHomeButtonPress{
    if (window.isBlackoutShowing) {
        [window endAnimation:YES clearBlackout:YES animated:YES];
    }else{
        %orig;
    }
}
-(void)_simulateHomeButtonPressWithCompletion:(/*^block*/id)arg1 {
    if (window.isBlackoutShowing) {
        [window endAnimation:YES clearBlackout:YES animated:YES];
    }else{
        %orig;
    }
}
- (void)_handleMenuButtonEvent {
    if (window.isBlackoutShowing) {
        [window endAnimation:YES clearBlackout:YES animated:YES];
    }else{
        %orig;
    }
}
%end
%hook SBHomeHardwareButton
-(void)singlePressUp:(id)arg1{
    if (window.isBlackoutShowing) {
        [window endAnimation:YES clearBlackout:YES animated:YES];
    }else{
        %orig;
    }
}
%end
%hook SBLockHardwareButton
-(void)singlePress:(id)arg1{
    if (window.isBlackoutShowing) {
        [window endAnimation:YES clearBlackout:YES animated:YES];
    }else{
        %orig;
    }
}
%end

//Locking methods
%hook SBLockScreenManager

-(void)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2{
    if (window.isShowing)
        [window endAnimation:YES clearBlackout:YES animated:YES];
    %orig;
}
-(void)_setUILocked:(BOOL)arg1{
    %orig;
    if (arg1){
        if (window.isShowing | window.isBlackoutShowing)
            [window endAnimation:YES clearBlackout:YES animated:NO];
    }
}
-(void)_lockScreenDimmed:(id)arg1{
    %orig;
    
    if (window.isShowing | window.isBlackoutShowing)
        [window endAnimation:YES clearBlackout:YES animated:NO];
}

%end

%hook SBLiftToWakeManager
// 11
-(void)liftToWakeController:(id)arg1 didObserveTransition:(long long)arg2 {
    %orig;
    if (window.isBlackoutShowing && arg2 == 2){
        [window endAnimation:YES clearBlackout:YES animated:YES];
    }
}

// 12
-(void)liftToWakeController:(id)arg1 didObserveTransition:(long long)arg2 deviceOrientation:(long long)arg3{
    %orig;
    if (window.isBlackoutShowing  && arg2 == 2){
        [window endAnimation:YES clearBlackout:YES animated:YES];
    }
}


-(BOOL)handleEvent:(id)arg1{
    BOOL o = %orig;
    
    if (window.isBlackoutShowing){
        return YES;
    }else{
        return o;
    }
}
%end





BOOL DNDEnabled = NO;
%hook DNDState

-(BOOL)isActive{
    bool o = %orig;
    DNDEnabled = o;
    return o;
}
%end

//Notification hooks

static BOOL isRealScreenOn;
%hook BBServer

// 11
-(void)publishBulletin:(BBBulletin *)bulletin destinations:(unsigned int)arg2 alwaysToLockScreen:(BOOL)arg3{
    isRealScreenOn = [[%c(SBBacklightController) sharedInstance] screenIsOn];
    %orig;
    if (arg2){
        [self receivedNotification:bulletin];
    }
}

// 12
-(void)publishBulletin:(BBBulletin *)bulletin destinations:(unsigned long long)arg2{
    isRealScreenOn = [[%c(SBBacklightController) sharedInstance] screenIsOn];
    %orig;
    if (arg2){
        [self receivedNotification:bulletin];
    }
}


%new
-(void)receivedNotification:(BBBulletin *)bulletin{
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
        //Locked
        if (([(SpringBoard*)[UIApplication sharedApplication] isLocked] && LSEnabled)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (showInDND && !isScreenOn && DNDEnabled){
                    [springboard _turnScreenOnOnDashBoardWithCompletion:nil];
                }
                [window showWithBlackout:isScreenOn?NO:blackout andBundleId:bulletin.sectionID isUnlocked:NO];
            });
        }

        //Unlocked
        if ((![(SpringBoard*)[UIApplication sharedApplication] isLocked] && SBEnabled)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [window showWithBlackout:NO andBundleId:bulletin.sectionID isUnlocked:YES];
            });
        }
    }
}

%end


// Apple Watch Fix
%hook NCNotificationOptions
-(BOOL)canTurnOnDisplay{
    if ([[EWindow settings][@"disableWatchFix"] boolValue]){
        return %orig;
    }else{
        return true;
    }
}
%end



// Disable idle timer
%hook SBDashBoardIdleTimerProvider
- (instancetype)initWithDelegate:(id)arg1 {
    %orig;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableIdleTimer) name:@"notchificationBegan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableIdleTimer) name:@"notchificationFinished" object:nil];
    return self;
}

%new - (void)disableIdleTimer {
    [self addDisabledIdleTimerAssertionReason:@"Notchification"];
    if (window.isBlackoutShowing){
        [[%c(SBLockScreenManager) sharedInstance] setBiometricAutoUnlockingDisabled:true forReason:@"Notchification"];
    }
}

%new - (void)enableIdleTimer {
    [self removeDisabledIdleTimerAssertionReason:@"Notchification"];
    [[%c(SBLockScreenManager) sharedInstance] setBiometricAutoUnlockingDisabled:false forReason:@"Notchification"];
}
%end

%hook NCNotificationListCell
-(void)cellClearButtonPressed:(id)arg1 {    
    %orig;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notchificationFinished" object:self];
    [window endAnimation:YES clearBlackout:YES animated:NO];
}
%end


