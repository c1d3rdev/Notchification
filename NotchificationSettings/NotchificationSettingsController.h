//
//  NotchificationSettingsController.h
//  NotchificationSettings
//
//  Created by Will Smillie on 7/17/18.
//  Copyright (c) 2018 ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>
#import "interfaces.h"
#import <spawn.h>
#import <L360Confetti/L360ConfettiArea.h>

@interface NotchificationSettingsController : PSListController <L360ConfettiAreaDelegate, PaywallViewControllerDelegate>{
    id colorPickerCell;
}


- (id)getValueForSpecifier:(PSSpecifier*)specifier;
- (void)setValue:(id)value forSpecifier:(PSSpecifier*)specifier;
- (void)followOnTwitter:(PSSpecifier*)specifier;
- (void)visitWebSite:(PSSpecifier*)specifier;
- (void)makeDonation:(PSSpecifier*)specifier;

@property(nonatomic, strong) L360ConfettiArea *confettiArea;
-(void)burst;

@end

