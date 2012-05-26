//
//  AppDelegate.h
//  tictactoe
//
//  Created by Steffen Buder on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameViewController.h"

#import "SettingsViewController.h"

#import "MapViewController.h"

#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController* viewController;

@property (strong, nonatomic) GameViewController *gameViewController;

@property (strong, nonatomic) SettingsViewController* settingsViewController;

@property (strong, nonatomic) MapViewController* mapViewController;

@end
