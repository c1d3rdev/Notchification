//
//  AnimationSelector.h
//  NotchificationSettings
//
//  Created by Will Smillie on 7/17/18.
//

#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>
#import <rocketbootstrap.h>

@interface AnimationSelector : PSListItemsController

@property BOOL previewWithBlackout;
@property (nonatomic, strong) NSArray *sortedDisplayIdentifiers;
@end
