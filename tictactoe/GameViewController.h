//
//  ViewController.h
//  tictactoe
//
//  Created by Steffen Buder on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "TicTacToeMatrix.h"

@interface GameViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *b1;
@property (strong, nonatomic) IBOutlet UIButton *b2;
@property (strong, nonatomic) IBOutlet UIButton *b3;
@property (strong, nonatomic) IBOutlet UIButton *b4;
@property (strong, nonatomic) IBOutlet UIButton *b5;
@property (strong, nonatomic) IBOutlet UIButton *b6;
@property (strong, nonatomic) IBOutlet UIButton *b7;
@property (strong, nonatomic) IBOutlet UIButton *b8;
@property (strong, nonatomic) IBOutlet UIButton *b9;

@property (strong, nonatomic) IBOutlet UILabel *label1;

- (IBAction)startAction:(id)sender;
- (IBAction)setImage:(id)sender;

@end
