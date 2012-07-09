//
//  SettingsViewController.h
//  tictactoe
//
//  Created by Steffen Buder on 14.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsModel.h"

@interface SettingsViewController : UIViewController

@property (retain, nonatomic) IBOutlet UISegmentedControl *gameModeSwitch;

@property (retain, nonatomic) IBOutlet UIButton *crossSelectButton;

@property (retain, nonatomic) IBOutlet UIButton *circleSelectButton;

@property (retain, nonatomic) IBOutlet UISegmentedControl *startingPlayerSwitch;

@property (retain, nonatomic) IBOutlet UITextField *gameServerField;

@property (retain, nonatomic) IBOutlet UITextField *nicknameField;

@property (nonatomic, retain) SettingsModel* model;

- (IBAction)setGameMode:(UISegmentedControl *)sender;

- (IBAction)setMyImage:(UIButton *)sender;

- (IBAction)setStartingPlayer:(UISegmentedControl *)sender;

- (IBAction)setGameServerAdress:(UITextField *)sender;

- (IBAction)setNickName:(UITextField *)sender;

@end
