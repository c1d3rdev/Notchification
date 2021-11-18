//
//  AnimationSelector.m
//  NotchificationSettings
//
//  Created by Will Smillie on 7/17/18.
//

#import "AnimationSelector.h"

#import "EWindow.h"
#import "interfaces.h"
#import <AppList/AppList.h>
#import <AppList.h>

static EWindow *window;
static CPDistributedMessagingCenter *c = nil;

@implementation AnimationSelector
@synthesize previewWithBlackout, sortedDisplayIdentifiers;


- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSLog(@"[Notch] It worked!");
    
    c = [NSClassFromString(@"CPDistributedMessagingCenter") centerNamed:@"com.c1d3r.notchification.center"];
    rocketbootstrap_distributedmessagingcenter_apply(c);

    previewWithBlackout = NO;
    
    UISwitch *blackoutSwitch = [[UISwitch alloc] initWithFrame: CGRectZero];
    [blackoutSwitch addTarget: self action: @selector(flip:) forControlEvents:UIControlEventValueChanged];
    [blackoutSwitch setTintColor:[UIColor blackColor]];
    [blackoutSwitch setOnTintColor:[UIColor blackColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:blackoutSwitch];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    window.alpha = 0;
}

- (IBAction)flip:(id)sender{
    UISwitch *onoff = (UISwitch *) sender;
    previewWithBlackout = onoff.on;
}


- (void)tableView:(id)view didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:view didSelectRowAtIndexPath:indexPath];
    
//    window.alpha = 1;
    [c sendMessageName:@"showAnimation" userInfo:@{@"animation": [NSString stringWithFormat:@"/Library/Notchification/%@", [[self animationValues] objectAtIndex:indexPath.row]],
                                                   @"blackout": [NSNumber numberWithBool:previewWithBlackout]
                                                   }];
    
//    [window showWithBlackout:previewWithBlackout andBundleId:@"com.apple.MobileSMS" isUnlocked:YES];
}



-(NSArray *)animationValues {
    NSMutableArray* files = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/Notchification/" error:nil] mutableCopy];
    if ([files containsObject:@"supporting_files"]) {
        [files removeObject:@"supporting_files"];
    }

    return files;
}

-(NSArray *)staticAnimationValues {
    NSMutableArray* files = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/Notchification/" error:nil] mutableCopy];
    
    for (NSString *f in files) {
        if ([f containsString:@"[responsive]"]) {
            [files removeObject:f];
        }
    }
    
    return files;
}


-(NSArray *)responsiveAnimationValues {
    NSMutableArray* files = [[self animationValues] mutableCopy];
    
    NSMutableArray *responsiveFiles = [[NSMutableArray alloc] init];
    for (NSString *file in files) {
        if ([file containsString:@"[responsive]"]) {
            [responsiveFiles addObject:file];
        }
    }

    return files;
}

@end
