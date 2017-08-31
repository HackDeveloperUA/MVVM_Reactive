//
//  AppDelegate.m
//  MVVM_NonReactive
//
//  Created by Uber on 27/07/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "AppDelegate.h"

// Router
#import "HDRouter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/*
EN: Attention ! This is a test version of the pattern, some decision tasks can differ from practical projects.

RU: Внимание ! Это тестовая версия паттерна, некоторые решение задач могут отличаться от практических проектов.
*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.window makeKeyAndVisible];
    

 
    [[HDRouter sharedRouter] openApplication];
    
    return YES;
}





@end
