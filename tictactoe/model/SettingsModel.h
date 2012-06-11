//
//  SettingsModel.h
//  tictactoe
//
//  Created by Steffen Buder on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsModel : NSObject

@property(copy, nonatomic) UIImage* player1Image;

@property(copy, nonatomic) UIImage* player2Image;

@property(copy, nonatomic) UIImage* player1WinImage;

@property(copy, nonatomic) UIImage* player2WinImage;

@property(nonatomic) bool amIStarting;

@property(retain, nonatomic) NSString* gameServerAdress;

@property(retain, nonatomic) NSString* nickname;

@property(nonatomic) int numPlayer;

@end
