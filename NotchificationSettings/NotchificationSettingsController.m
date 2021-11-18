//
//  NotchificationSettingsController.m
//  NotchificationSettings
//
//  Created by Will Smillie on 7/17/18.
//  Copyright (c) 2018 ___ORGANIZATIONNAME___. All rights reserved.
//

#import "NotchificationSettingsController.h"
#import <Preferences/PSSpecifier.h>

#import <JBBulletinManager.h>

#define kSetting_Example_Name @"mode"
#define kSetting_Example_Value @"ValueOfAnExampleSetting"

#define kSetting_TemplateVersion_Name @"TemplateVersionExample"
#define kSetting_TemplateVersion_Value @"1.0"

#define kSetting_Text_Name @"TextExample"
#define kSetting_Text_Value @"Go Red Sox!"

#define kUrl_FollowOnTwitter @"https://twitter.com/c1d3rDev"
#define kUrl_FollowAhmedOnTwitter @"https://twitter.com/lazynagy"
#define kUrl_VisitWebSite @"http://iosopendev.com"
#define kUrl_MakeDonation @"https://paypal.me/willsmillie"

#define kPrefs_Path @"/var/mobile/Library/Preferences"
#define kPrefs_KeyName_Key @"key"
#define kPrefs_KeyName_Defaults @"defaults"


@interface NotchificationSettingsController()<PaywallViewControllerDelegate>{}
@end

@implementation NotchificationSettingsController
@synthesize confettiArea;

-(void)viewDidLoad{
    [super viewDidLoad];
    
//    UIBarButtonItem* respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Test Notification" style:UIBarButtonItemStylePlain target:self action:@selector(confirmRespring:)];
//    self.navigationItem.rightBarButtonItem = respringButton;
    
    self.table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    colorPickerCell = [self specifierForID:@"overrideColor"];
        
    [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void)burst{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please Respring!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self respring];
    }]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
    
    [confettiArea burstAt:confettiArea.center confettiWidth:10.0f numberOfConfetti:60];
}

-(void)paywallViewControllerDidCompleteAuthorization:(PaywallViewController *)paywallViewController{
    [self burst];
}

-(void)paywallViewControllerDidCancel:(PaywallViewController *)paywallViewController{
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (id)getValueForSpecifier:(PSSpecifier*)specifier
{
	id value = nil;
	
	NSDictionary *specifierProperties = [specifier properties];
	NSString *specifierKey = [specifierProperties objectForKey:kPrefs_KeyName_Key];
	
    // ...or get 'value' from 'defaults' plist or (optionally as a default value) with code
    // get 'value' from 'defaults' plist (if 'defaults' key and file exists)
    NSMutableString *plistPath = [[NSMutableString alloc] initWithString:[specifierProperties objectForKey:kPrefs_KeyName_Defaults]];
    #if ! __has_feature(objc_arc)
    plistPath = [plistPath autorelease];
    #endif
    if (plistPath)
    {
        NSDictionary *dict = (NSDictionary*)[self initDictionaryWithFile:&plistPath asMutable:NO];
        
        id objectValue = [dict objectForKey:specifierKey];
        
        if (objectValue)
        {
            value = [NSString stringWithFormat:@"%@", objectValue];
            NSLog(@"read key '%@' with value '%@' from plist '%@'", specifierKey, value, plistPath);
        }
        else
        {
            NSLog(@"key '%@' not found in plist '%@'", specifierKey, plistPath);
        }
        
        #if ! __has_feature(objc_arc)
        [dict release];
        #endif
    }
    
    // get default 'value' from code
    if (!value)
    {
        if ([specifierKey isEqual:kSetting_Text_Name])
        {
            value = kSetting_Text_Value;
        }
        else if ([specifierKey isEqual:kSetting_Example_Name])
        {
            value = kSetting_Example_Value;
        }
    }
	
	return value;
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier*)specifier;
{
	NSDictionary *specifierProperties = [specifier properties];
	NSString *specifierKey = [specifierProperties objectForKey:kPrefs_KeyName_Key];

    NSLog(@"[Notch] Setting value for %@", specifierKey);
    
    // save 'value' to 'defaults' plist (if 'defaults' key exists)
    NSMutableString *plistPath = [[NSMutableString alloc] initWithString:[specifierProperties objectForKey:kPrefs_KeyName_Defaults]];
    #if ! __has_feature(objc_arc)
    plistPath = [plistPath autorelease];
    #endif
    if (plistPath)
    {
        NSMutableDictionary *dict = (NSMutableDictionary*)[self initDictionaryWithFile:&plistPath asMutable:YES];
        [dict setObject:value forKey:specifierKey];
        [dict writeToFile:plistPath atomically:YES];
        #if ! __has_feature(objc_arc)
        [dict release];
        #endif

        NSLog(@"[Notch] saved key '%@' with value '%@' to plist '%@'", specifierKey, value, plistPath);
    }
}

- (id)initDictionaryWithFile:(NSMutableString**)plistPath asMutable:(BOOL)asMutable
{
	if ([*plistPath hasPrefix:@"/"])
		*plistPath = [NSString stringWithFormat:@"%@.plist", *plistPath];
	else
		*plistPath = [NSString stringWithFormat:@"%@/%@.plist", kPrefs_Path, *plistPath];
	
	Class class;
	if (asMutable)
		class = [NSMutableDictionary class];
	else
		class = [NSDictionary class];
	
	id dict;	
	if ([[NSFileManager defaultManager] fileExistsAtPath:*plistPath])
		dict = [[class alloc] initWithContentsOfFile:*plistPath];	
	else
		dict = [[class alloc] init];
	
	return dict;
}

- (void)followOnTwitter:(PSSpecifier*)specifier
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_FollowOnTwitter]];
}

- (void)followAhmedOnTwitter:(PSSpecifier*)specifier
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_FollowAhmedOnTwitter]];
}

- (void)submitAnimation:(PSSpecifier*)specifier
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Submit Animations" message:@"Email a .aep file to c1d3rdev@gmail.com\n\nTry to keep it as simple as possible, because the renderer can be picky. Expressions and Effects are unsupported.\n\n Shoot me an email or tweet if you have any questions!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)makeDonation:(PSSpecifier *)specifier
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_MakeDonation]];
}

- (id)specifiers
{
	if (_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"NotchificationSettings" target:self];
		#if ! __has_feature(objc_arc)
		[_specifiers retain];
		#endif
	}
    
//    // create a temporary specifiers array (mutable)
//    NSMutableArray *specifiers = [[NSMutableArray alloc] init];
//
//
//    for (PSSpecifier *specifier in _specifiers) {
//        BOOL alwaysOn = NO;
//
//
//        if ([specifier.identifier isEqualToString:@"Always On"]) {
////            alwaysOn = [specifier values];
//            NSLog(@"[Notch] switch: %@", [specifier values]);
//        }
//    }
//
    
    
    return _specifiers;
}




- (id)init
{
	if ((self = [super init]))
	{
	}
	
	return self;
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
	[super dealloc];
}
#endif



-(NSArray *)animationTitles {
    NSMutableArray* files = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/Notchification/" error:nil] mutableCopy];
    for (int i=0; i<files.count; i++) {
        NSString *thisTheme = files[i];
        thisTheme = [thisTheme stringByReplacingOccurrencesOfString:@".json" withString:@""];
        [files replaceObjectAtIndex:i withObject:thisTheme];
    }
    
    if ([files containsObject:@"supporting_files"]) {
        [files removeObject:@"supporting_files"];
    }
    
    return files;
}

-(NSArray *)animationValues {
    NSMutableArray* files = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/Notchification/" error:nil] mutableCopy];
    if ([files containsObject:@"supporting_files"]) {
        [files removeObject:@"supporting_files"];
    }
    return files;
}


//-(IBAction)confirmRespring:(id)sender{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[NSClassFromString(@"JBBulletinManager") sharedInstance] showBulletinWithTitle:@"Notchification" message:@"This is a test notification!" bundleID:@"com.apple.MobileSMS"];
//    });
//
//
////    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure you want to respring?" preferredStyle:UIAlertControllerStyleAlert];
////    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
////
////    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
////        [self respring];
////    }];
////    [alertController addAction:cancelAction];
////    [alertController addAction:okAction];
////
////    [self presentViewController:alertController animated:YES completion:nil];
//}

-(void)respring{
    pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

@end
