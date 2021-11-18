//
//  3EWindow.m
//
//
//  Created by William Smillie on 8/12/17.
//
//

#import "EWindow.h"
#import "interfaces.h"
#import <libcolorpicker.h>
#import <ColorPicker.h>


@implementation UIColor (LightAndDark)

- (UIColor *)lighterColor
{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:MIN(b * 1.5, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColor
{
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
    BOOL loopUntilInteraction;
    CPDistributedMessagingCenter * _messagingCenter;
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
        self.windowLevel = UIWindowLevelAlert + 999;
        [self setHidden:NO];
        
        
        _messagingCenter = [NSClassFromString(@"CPDistributedMessagingCenter") centerNamed:@"com.c1d3r.notchification.center"];
        rocketbootstrap_distributedmessagingcenter_apply(_messagingCenter);
        [_messagingCenter runServerOnCurrentThread];
        [_messagingCenter registerForMessageName:@"showAnimation" target:self selector:@selector(handleMessageNamed:withUserInfo:)];

        
        self.colorCube = [[CCColorCube alloc] init];;

        self.blackoutView = [[UIView alloc] initWithFrame:self.bounds];
        self.blackoutView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackoutTapped:)];
        [self.blackoutView addGestureRecognizer:tap];
        [self addSubview:self.blackoutView];
        
        self.blackoutView.alpha = 0;
        self.blackoutView.userInteractionEnabled = NO;
        self.userInteractionEnabled = NO;

        
        NSDictionary *dict = [EWindow settings];
        if ([dict[@"animation"] length] > 0) {
            NSLog(@"[Notch] animation exists: %@", dict[@"animation"]);
            self.animationPath = [NSString stringWithFormat:@"/Library/Notchification/%@", dict[@"animation"]];
        }else{
            NSLog(@"[Notch] animation does not exist, are we sure: %@", dict[@"animation"]);
            self.animationPath = [NSString stringWithFormat:@"/Library/Notchification/particles/animation.json"];
        }
        [self makeKeyAndVisible];
    }
    return self;
}

- (void)handleMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
    if ([name isEqualToString:@"showAnimation"]) {
        [self setAnimationPath:userInfo[@"animation"]];
        [self showWithBlackout:[userInfo[@"blackout"] boolValue] andBundleId:@"com.apple.MobileSMS" isUnlocked:YES];
    }
}

-(void)makeKeyAndVisible{
    [super makeKeyAndVisible];
}

-(IBAction)blackoutTapped:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notchificationFinished" object:self];
    [self endAnimation:YES clearBlackout:YES animated:YES];
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
    self.animationView.contentMode = ([[[EWindow settings][@"aspectRatio"] stringValue] isEqualToString:@"fill"] ? UIViewContentModeScaleToFill : UIViewContentModeScaleAspectFit);
    self.animationView.userInteractionEnabled = NO;
    self.animationView.loopAnimation = YES;
    self.animationView.alpha = 0;
    [self addSubview:self.animationView];
}


-(void)showWithBlackout:(BOOL)blackout andBundleId:(NSString *)bundleId isUnlocked:(BOOL)isUnlocked{
    self.isShowing = YES;
    self.animationView.alpha = 1;
        
    if ([[EWindow settings][@"alwayson"] boolValue]) {
        blackout = NO;
    }
    
    if (bundleId && self.animationProperties != nil) {
        [self colorLayersForBundleId:bundleId];
    }
    

    
    if (blackout) {
        float oledDelay = [[EWindow settings][@"oledDelay"] floatValue];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, oledDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:oledDelay > 0 ? 0.3 : 0 animations:^{
                self.blackoutView.alpha = 1;
            } completion:nil];
            self.isBlackoutShowing = YES;
            self.userInteractionEnabled = YES;
            self.blackoutView.userInteractionEnabled = YES;
        });
    }else{
        self.blackoutView.alpha = 0;
        self.isBlackoutShowing = NO;
        self.userInteractionEnabled = NO;
        self.blackoutView.userInteractionEnabled = NO;
    }
    
    self.animationView.animationProgress = 0;
    self.animationView.loopAnimation = YES;
    [self.animationView play];

    
    if (![[EWindow settings][@"alwayson"] boolValue]) {
        if (!isUnlocked) {
        
            float loops = [[EWindow settings][@"loops"] floatValue];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notchificationBegan" object:self];

            if (loops != 0) { //If it's not infinite
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timerDidFinish) object:nil];
                [self performSelector:@selector(timerDidFinish) withObject:nil afterDelay:(self.animationView.animationDuration*loops)];
            }
        }else{
            float loops = [[EWindow settings][@"sbLoops"] floatValue];
            
            if (loops != 0) { //If it's not infinite
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timerDidFinish) object:nil];
                [self performSelector:@selector(timerDidFinish) withObject:nil afterDelay:(self.animationView.animationDuration*loops)];
            }
        }
    }
}

-(void)timerDidFinish{
    BOOL isLocked = [(SpringBoard*)[UIApplication sharedApplication] isLocked];
    BOOL endBlackout = [[EWindow settings][@"lswakeafteranimating"] boolValue];
    [self endAnimation:YES clearBlackout:isLocked?endBlackout:YES animated:YES];
}


-(void)endAnimation:(BOOL)end clearBlackout:(BOOL)clear animated:(BOOL)animated{
    CGFloat duration = animated?0.5:0;

    end = [[EWindow settings][@"alwayson"] boolValue]?NO:end;
    
    if (end) {
        self.isShowing = NO;
        [UIView animateWithDuration:duration animations:^{
            self.animationView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.animationView stop];
        }];
    }
    
    if (clear) {
        self.isBlackoutShowing = NO;
        self.userInteractionEnabled = NO;
        self.blackoutView.userInteractionEnabled = NO;
        [UIView animateWithDuration:duration animations:^{
            self.blackoutView.alpha = 0;
        }];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notchificationFinished" object:self];
}

//13 icon gen
- (UIImage *)iconImageForIdentifier:(NSString *)identifier {
    
    SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];
    SBIcon *icon = [iconController.model expectedIconForDisplayIdentifier:identifier];
    
    struct CGSize imageSize;
    imageSize.height = 60;
    imageSize.width = 60;
    
    struct SBIconImageInfo imageInfo;
    imageInfo.size  = imageSize;
    imageInfo.scale = [UIScreen mainScreen].scale;
    imageInfo.continuousCornerRadius = 12;
    
    return [icon generateIconImageWithInfo:imageInfo];
}



#pragma mark - helpers

-(void)colorLayersForBundleId:(NSString *)bundleId{
    UIImage *icon;
    if (@available(iOS 13, *)) {
        icon = [self iconImageForIdentifier:bundleId];
    } else {
        SBApplication *app = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:bundleId];
        id appIcon = [[NSClassFromString(@"SBApplicationIcon") alloc] initWithApplication:app];
        icon = [appIcon generateIconImage:1];
    };
    
    NSArray *imgColors = [self.colorCube extractColorsFromImage:icon flags:CCOnlyDistinctColors|CCAvoidWhite|CCAvoidBlack count:1];
    
    if ([[EWindow settings][@"responsiveOverride"] boolValue]) {
        NSString *coolColorHex = [[EWindow settings] objectForKey:@"overrideColor"];
        UIColor *coolColor = LCPParseColorString(coolColorHex, @"#ff0000");
        imgColors = [[NSArray alloc] initWithObjects:coolColor, nil];
    }
    
    if (imgColors.count > 0) {
        NSArray *layersToColor = self.animationProperties[@"colors"];
        
        if (layersToColor.count > 1) {
            for (NSString *k in layersToColor) {
                int r = arc4random_uniform(3);
                UIColor *color;
                
                if (r == 0) {
                    color = imgColors[0];
                }else if (r==1){
                    color = [imgColors[0] lighterColor];
                }else{
                    color = [imgColors[0] darkerColor];
                }
                
                LOTKeypath *kp = [LOTKeypath keypathWithString:k];
                LOTColorValueCallback *callback = [LOTColorValueCallback withCGColor:color.CGColor];
                [self.animationView setValueDelegate:callback forKeypath:kp];
                //                        [self.retainerArray addObject:callback];
            }
        }else{
            LOTKeypath *kp = [LOTKeypath keypathWithString:layersToColor[0]];
            LOTColorValueCallback *callback = [LOTColorValueCallback withCGColor:[imgColors[0] CGColor]];
            [self.animationView setValueDelegate:callback forKeypath:kp];
            //                    [self.retainerArray addObject:callback];
        }
    }
}


#pragma mark - settings

+(NSString*)settingsPath{
    return [NSString stringWithFormat:@"%@/Library/Preferences/%@", NSHomeDirectory(), @"com.c1d3r.NotchificationSettings.plist"];
}
+(NSMutableDictionary *)settings{
    return [NSMutableDictionary dictionaryWithContentsOfFile:[self settingsPath]];
}

- (bool)_shouldCreateContextAsSecure{
    return YES;
}

@end
