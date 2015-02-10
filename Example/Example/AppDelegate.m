//
//  AppDelegate.m
//  GHUICatalog
//
//  Created by Gabriel Handford on 11/5/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "AppDelegate.h"

#import <GHUITable/GHUITable.h>

#import "GHMainView.h"

@interface GHUITableViewController : UIViewController
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
  
  GHUITableViewController *viewController = [[GHUITableViewController alloc] init];
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
  self.window.rootViewController = navigationController;
  
  [self.window makeKeyAndVisible];
  return YES;
}

@end

@implementation GHUITableViewController

- (void)loadView {
  self.title = @"Examples";
  GHMainView *mainView = [[GHMainView alloc] init];
  mainView.navigationController = self.navigationController;
  self.view = mainView;
}

@end
