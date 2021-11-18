//
//  ViewController.m
//  notchtest
//
//  Created by Will Smillie on 7/26/18.
//  Copyright © 2018 Red Door Endeavors. All rights reserved.
//

#import "ViewController.h"
#import <INTUAnimationEngine/INTUInterpolationFunctions.h>
#import <INTUAnimationEngine/INTUEasingFunctions.h>

#define f  1.05

@interface ViewController (){
    int animationIndex;
    
}
@end

@implementation ViewController
@synthesize animationView;

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    animationIndex = -1;
    
    [self completion];
    
    
    self.view.backgroundColor = [UIColor blackColor];

    
    self.array = [[NSMutableArray alloc] init];
    
    NSArray *keys = @[@"**.Color"];
    //    for (NSString *key in keys) {
//        LOTKeypath *kp = [LOTKeypath keypathWithString:key];
//        LOTColorValueCallback *callback = [LOTColorValueCallback withCGColor:[UIColor redColor].CGColor];
//        [self.array addObject:callback];
//        [animationView setValueDelegate:callback forKeypath:kp];
//    }
}



-(void)completion{
    animationIndex++;
    
//    [animationView removeFromSuperview];
//    animationView = nil;
    
    animationView = [LOTAnimationView animationNamed:[NSString stringWithFormat:@"animation.json"]];
    animationView.frame = [UIScreen mainScreen].bounds;

    
//    [animationView logHierarchyKeypaths];
    
//    LOTKeypath *kp2 = [LOTKeypath keypathWithString:@"drop2.Shape 1.Fill 1.Color"];
//    LOTColorValueCallback *callback2 = [LOTColorValueCallback withCGColor:[UIColor redColor].CGColor];
//    [animationView setValueDelegate:callback2 forKeypath:kp2];

    
    [animationView setLoopAnimation:YES];
    animationView.contentMode = UIViewContentModeScaleAspectFit;
    animationView.animationSpeed = 0.5;
    

    
    
    

    
    LOTKeypath *kp = [LOTKeypath keypathWithString:@"**.Color"];
    _colorInterpolator = [LOTColorBlockCallback withBlock:^CGColorRef _Nonnull(CGFloat currentFrame, CGFloat startKeyFrame, CGFloat endKeyFrame, CGFloat interpolatedProgress, CGColorRef  _Nullable startColor, CGColorRef  _Nullable endColor, CGColorRef  _Nullable interpolatedColor) {
        return [UIColor blueColor].CGColor;
    }];
    [animationView setValueDelegate:_colorInterpolator forKeypath:kp];


    
    [self.view addSubview:animationView];
    
    
    
//    LOTKeypath *end = [LOTKeypath keypathWithString:@"**.End"];
//    _endInterpolator = [LOTNumberBlockCallback withBlock:^CGFloat(CGFloat currentFrame, CGFloat startKeyFrame, CGFloat endKeyFrame, CGFloat interpolatedProgress, CGFloat startValue, CGFloat endValue, CGFloat interpolatedValue) {
//        if (currentFrame <= 30) {
//            return [self rangeToPercentageWithMin:0 inMax:30 outMin:0 outMax:(battery * 100) andValue:30*INTUEaseOutSine(currentFrame/30)];
//        }else if (currentFrame >= 90){
//            return [self rangeToPercentageWithMin:90 inMax:120 outMin:(battery * 100) outMax:100 andValue:currentFrame*INTUEaseOutExponential(currentFrame/120)];
//        }else{
//            return [self rangeToPercentageWithMin:0 inMax:30 outMin:0 outMax:(battery * 100) andValue:30];
//        }
//    }];
//    [animationView setValueDelegate:_endInterpolator forKeypath:end];
//
//
//    LOTKeypath *start = [LOTKeypath keypathWithString:@"**.Start"];
//    _startInterpolator = [LOTNumberBlockCallback withBlock:^CGFloat(CGFloat currentFrame, CGFloat startKeyFrame, CGFloat endKeyFrame, CGFloat interpolatedProgress, CGFloat startValue, CGFloat endValue, CGFloat interpolatedValue) {
//        if (currentFrame >= 90) {
//            return [self rangeToPercentageWithMin:90 inMax:120 outMin:0 outMax:100 andValue:currentFrame*INTUEaseOutExponential(currentFrame/120)];
//        }else{
//            return 0;
//        }
//    }];
//
//    [animationView setValueDelegate:_startInterpolator forKeypath:start];
    [animationView play];
}

-(float)rangeToPercentageWithMin:(float)inMin inMax:(float)inMax outMin:(float)outMin outMax:(float)outMax andValue:(float)value{
    return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
