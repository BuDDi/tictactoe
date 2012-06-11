//
//  SettingsModel.m
//  tictactoe
//
//  Created by Steffen Buder on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsModel.h"

@implementation SettingsModel

@synthesize player1Image = _player1Image;

@synthesize player1WinImage = _player1WinImage;

@synthesize player2Image = _player2Image;

@synthesize player2WinImage = _player2WinImage;

@synthesize amIStarting = _amIStarting;

@synthesize gameServerAdress = _gameServerAdress;

@synthesize nickname = _nickname;

@synthesize numPlayer = _numPlayer;

-(id) init {
    self = [super init];
    if (self) {
        // TODO default-werte setzen
        _player1Image = [UIImage imageNamed:@"kreuz.png"];
        _player1WinImage = [UIImage imageNamed:@"kreuz_win.png"];
        _player2Image = [UIImage imageNamed:@"kreis.png"];
        _player2WinImage = [UIImage imageNamed:@"kreis_win.png"];
        _numPlayer = 1;
        _amIStarting = YES;
    }
    return self;
}

- (void)dealloc {
    [_player1Image release];
    [_player1WinImage release];
    [_player2Image release];
    [_player2WinImage release];
    [super dealloc];
}

@end
