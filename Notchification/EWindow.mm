#line 1 "/Users/willsmillie/Desktop/Dev/iOS/Jailbreak/Notchification/Notchification/EWindow.xm"








#import "EWindow.h"
#import "interfaces.h"
#import <ColorPicker.h>

@implementation UIColor (LightAndDark)


- (UIColor *)lighterColor {
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:MIN(b * 1.5, 1.0)
                               alpha:a];
    return nil;
}


- (UIColor *)darkerColor {
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.85
                               alpha:a];
    return nil;
}
@end


@interface EWindow (){
    NSTimer *autoOffTimer;
    BOOL loopUntilInteraction;
}
@end

@implementation EWindow

+ (id)sharedWindow {
    static EWindow *window = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        window = [[self alloc] init];
    });
    
    return window;
}


- (id)init{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self){
        self.windowLevel = UIWindowLevelAlert + 2;
        [self setHidden:NO];
        self.alpha = 0;
        
        self.colorCube = [[CCColorCube alloc] init];;

        self.blackoutView = [[UIView alloc] initWithFrame:self.bounds];
        self.blackoutView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackoutTapped:)];
        [self.blackoutView addGestureRecognizer:tap];
        [self addSubview:self.blackoutView];
        
        NSDictionary *dict = [EWindow settings];
        if ([dict[@"animation"] length] > 0) {
            NSLog(@"[Notch] animation exists: %@", dict[@"animation"]);
            self.animationPath = [NSString stringWithFormat:@"/Library/Notchification/%@", dict[@"animation"]];
        }else{
            NSLog(@"[Notch] animation does not exist, are we sure: %@", dict[@"animation"]);
            self.animationPath = [NSString stringWithFormat:@"/Library/Notchification/particles/animation.json"];
        }
    }
    return self;
    [self makeKeyAndVisible];
}

-(void)makeKeyAndVisible{
    [super makeKeyAndVisible];
}

-(IBAction)blackoutTapped:(id)sender{
    [self privateEndAnimated];
}

-(void)setAnimationPath:(NSString *)animationPath{
    loopUntilInteraction = [[EWindow settings][@"loopUntilInteraction"] boolValue];

    if ([animationPath containsString:@"[responsive] "]) {
        _animationPath = [NSString stringWithFormat:@"%@/animation.json", animationPath];
        self.animationProperties = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/animation.plist", animationPath]];
    }else{
        _animationPath = animationPath;
        self.animationProperties = nil;
    }

    [self.animationView removeFromSuperview];
    self.animationView = nil;
    
    self.animationView = [LOTAnimationView animationWithFilePath:_animationPath];
    self.animationView.frame = self.bounds;
    self.animationView.contentMode = UIViewContentModeScaleAspectFit;
    self.animationView.userInteractionEnabled = NO;
    self.animationView.loopAnimation = YES;
    [self addSubview:self.animationView];
}


-(void)showWithBlackout:(BOOL)blackout andBundleId:(NSString *)bundleId{
    [self.animationView stop];
    self.isShowing = YES;
    self.alpha = 1;
    
    if (autoOffTimer != nil) {
        if (autoOffTimer.isValid) {
            [autoOffTimer invalidate];
        }
    }
    
    if (bundleId && self.animationProperties != nil) {
        SBApplication *app = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:bundleId];
        SBApplicationIcon *appIcon = [[NSClassFromString(@"SBApplicationIcon") alloc] initWithApplication:app];
        UIImage *icon = [appIcon generateIconImage:1];
        
        NSArray<UIColor *> *imgColors = [self.colorCube extractColorsFromImage:icon flags:CCOnlyDistinctColors|CCAvoidWhite|CCAvoidBlack count:1];
        
        if ([[EWindow settings][@"responsiveOverride"] boolValue]) {
            NSString *coolColorHex = [[EWindow settings] objectForKey:@"overrideColor"];
            UIColor *coolColor = LCPParseColorString(coolColorHex, @"#ff0000");

            imgColors = @[coolColor];
        }
        
        if (imgColors.count > 0) {
            NSLog(@"[Notch] plist: %@", self.animationProperties);
            
            NSArray *layersToColor = self.animationProperties[@"colors"];
            [self.animationView logHierarchyKeypaths];
            
            if (layersToColor.count > 1) {
                for (NSString *k in layersToColor) {
                    
                    NSLog(@"[Notch] coloring: %@", k);
                    
                    int r = arc4random_uniform(3);
                    UIColor *color;
                    
                    switch (r) {
                        case 0:
                            color = imgColors[0];
                            break;
                        case 1:
                            color = [imgColors[0] lighterColor];
                            break;
                        case 2:
                            color = [imgColors[0] darkerColor];
                            break;
                    }
                    
                    
                    LOTKeypath *kp = [LOTKeypath keypathWithString:k];
                    LOTColorValueCallback *callback = [LOTColorValueCallback withCGColor:color.CGColor];
                    [self.animationView setValueDelegate:callback forKeypath:kp];
                }
            }else{
                LOTKeypath *kp = [LOTKeypath keypathWithString:layersToColor[0]];
                LOTColorValueCallback *callback = [LOTColorValueCallback withCGColor:imgColors[0].CGColor];
                [self.animationView setValueDelegate:callback forKeypath:kp];
            }
        }
    }else{
        NSLog(@"[Notch] No BundleId");
    }
    
    [self.animationView logHierarchyKeypaths];

    LOTKeypath *kp = [LOTKeypath keypathWithString:@"**.Fill 1.Color"];
    LOTColorValueCallback *callback = [LOTColorValueCallback withCGColor:[UIColor redColor].CGColor];
    [self.animationView setValueDelegate:callback forKeypath:kp];
    

    if (blackout) {
        self.blackoutView.alpha = 1;
        self.isBlackoutShowing = YES;
        self.userInteractionEnabled = YES;
    }else{
        self.blackoutView.alpha = 0;
        self.isBlackoutShowing = NO;
        self.userInteractionEnabled = NO;
    }
    
    self.animationView.animationProgress = 0;
    self.animationView.loopAnimation = YES;
    [self.animationView play];

    
    
    NSLog(@"[Notch] Will Call end animation in %f seconds", self.animationView.animationDuration);
    
    if (!loopUntilInteraction | ![[NSClassFromString(@"SBLockScreenManager") sharedInstance] isUILocked]) {
        autoOffTimer = [NSTimer scheduledTimerWithTimeInterval:self.animationView.animationDuration-0.5 target:self selector:@selector(privateEndAnimated) userInfo:nil repeats:NO];
    }
}

-(void)privateEndAnimated{
    autoOffTimer = nil;
    [self endAnimated:YES];
}

-(void)endAnimated:(BOOL)animated{
    NSLog(@"[Notch] end animated: %@", animated?@"YES":@"NO");
    
    CGFloat duration = 0;
    if (animated) {
        duration = 0.5;
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.blackoutView.alpha = 0;
        
        [self.animationView stop];
        self.isShowing = NO;
        self.isBlackoutShowing = NO;
    }];
}

-(void)endBlackoutAnimated:(BOOL)animated{
    CGFloat duration = 0;
    if (animated) {
        duration = 0.5;
    }

    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.blackoutView.alpha = 0;
        self.isBlackoutShowing = NO;
    }];
}
    


- (bool)_shouldCreateContextAsSecure{
  return YES;
}



#pragma mark - settings

+(NSString*)settingsPath{
    return [NSString stringWithFormat:@"%@/Library/Preferences/%@", NSHomeDirectory(), @"com.c1d3r.NotchificationSettings.plist"];
}
+(NSMutableDictionary *)settings{
    return [NSMutableDictionary dictionaryWithContentsOfFile:[self settingsPath]];
}

@end
