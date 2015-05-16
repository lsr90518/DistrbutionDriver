//
//  AppDelegate.m
//  DistributionDriver
//
//  Created by Lsr on 4/21/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "AppDelegate.h"
#import "MDAPI.h"
#import <CoreData/CoreData.h>
#import "MDCustomer.h"
#import "MDSQLManager.h"
#import "MDCustomerDAO.h"
#import "MDUser.h"
#import "MDDevice.h"
#import "MDCurrentPackage.h"
#import "MDMyPackageService.h"
#import "SRGVersionUpdater.h"
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"b3bf459fee27b33c2f19f338b31b00b8e4590f72"];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        // 这里判断是否第一次
        NSLog(@"first time");
    }
    
    //init navigationBar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // NavigationBar Image
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBarBg"] forBarMetrics:UIBarMetricsDefault];
        // Customize the title text for *all* UINavigationBars
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset, [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont, nil]];
        
    }else{
        
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBarBg"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        // Titles
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor whiteColor],
                                                               UITextAttributeTextColor,
                                                               [UIFont fontWithName:@"HiraKakuProN-W6" size:16],
                                                               UITextAttributeFont,
                                                               nil]];
    }
    
    [self configure];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[MDIndexViewController alloc] init];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    // force update check
    SRGVersionUpdater *versionUpdater = [SRGVersionUpdater new];
    versionUpdater.endPointUrl = [NSString stringWithFormat:@"http://%@/versions/ios_driver.json", API_HOST_NAME];
    [versionUpdater executeVersionCheck];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // force update check
    SRGVersionUpdater *versionUpdater = [SRGVersionUpdater new];
    versionUpdater.endPointUrl = [NSString stringWithFormat:@"http://%@/versions/ios_driver.json", API_HOST_NAME];
    [versionUpdater executeVersionCheck];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) configure {
    //core data
    //open api
    
    MDSQLManager *sqlManager = [[MDSQLManager alloc]init];
    [sqlManager initCoreData];
    MDAPI *api = [[MDAPI alloc]init];
    MDCustomerDAO   *customerDAO = [[MDCustomerDAO alloc]init];
    MDCurrentPackage *currentPackage = [[MDCurrentPackage alloc]init];
    [[MDCurrentPackage getInstance]initData];
    MDMyPackageService *myPackageService = [[MDMyPackageService alloc]init];
    
    MDUser *customer = [customerDAO findCustomer];
    [customer initDataClear];
    
    [self checkIOS7];
}

- (void)checkIOS7
{
    NSArray  *aOsVersions = [[[UIDevice currentDevice]systemVersion] componentsSeparatedByString:@"."];
    NSInteger iOsVersionMajor  = [[aOsVersions objectAtIndex:0] intValue];
    if (iOsVersionMajor == 7)
    {
        [MDDevice getInstance].iosVersion = @"7";
    } else {
        [MDDevice getInstance].iosVersion = @"8";
    }
}

-(void)initDB {
    MDCustomerDAO   *customerDAO = [[MDCustomerDAO alloc]init];
    [customerDAO deleteCustomer];
}


@end
