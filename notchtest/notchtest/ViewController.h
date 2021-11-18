//
//  ViewController.h
//  notchtest
//
//  Created by Will Smillie on 7/26/18.
//  Copyright © 2018 Red Door Endeavors. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Lottie/Lottie.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) LOTAnimationView *animationView;
@property (strong, nonatomic) LOTColorBlockCallback *colorInterpolator;
@property (strong, nonatomic) LOTNumberBlockCallback *endInterpolator;
@property (strong, nonatomic) LOTNumberBlockCallback *startInterpolator;

@property (nonatomic, retain) NSMutableArray *array;

@end

