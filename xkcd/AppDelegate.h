//
//  AppDelegate.h
//  xkcd
//
//  Created by Tyler Stromberg on 9/19/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorldViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WorldViewController *worldViewController;

@end
