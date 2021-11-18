//
//  3EWindow.h
//
//
//  Created by William Smillie on 8/12/17.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Lottie/Lottie.h>
#import <rocketbootstrap.h>

#import "CCColorCube.h"

#import "substrate.h"
#import "logos/logos.h"

@interface EWindow : UIWindow

+ (id)sharedWindow;

@property BOOL isShowing;
@property BOOL isBlackoutShowing;

@property (nonatomic, strong) CCColorCube *colorCube;

@property (nonatomic, strong) NSString *animationPath;
@property (nonatomic, strong) NSDictionary *animationProperties;

@property (nonatomic, strong) LOTAnimationView *animationView;
//@property (nonatomic, strong) NSMutableArray *retainerArray;
@property (nonatomic, strong) UIView *blackoutView;

-(void)showWithBlackout:(BOOL)blackout andBundleId:(NSString *)bundleId isUnlocked:(BOOL)isUnlocked;
-(void)endAnimation:(BOOL)end clearBlackout:(BOOL)clear animated:(BOOL)animated;

+(NSString*)settingsPath;
+(NSMutableDictionary *)settings;
@end
