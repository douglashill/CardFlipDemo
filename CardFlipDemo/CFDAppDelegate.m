//
//  CFDAppDelegate.m
//  CardFlipDemo
//
//  Created by Douglas Hill on 16/03/2013.
//  Copyright (c) 2013 Douglas Hill. All rights reserved.
//

#import "CFDAppDelegate.h"
#import "CFDViewController.h"

@implementation CFDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];
	[[self window] setRootViewController:[[CFDViewController alloc] init]];
	[self.window makeKeyAndVisible];
	return YES;
}

@end
