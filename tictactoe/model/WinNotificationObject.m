//
//  WinNotificationObject.m
//  tictactoe
//
//  Created by Steffen Buder on 21.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WinNotificationObject.h"

@implementation WinNotificationObject

@synthesize orientation = _orientation;
@synthesize winner = _winner;
@synthesize startField = _startField;

-(id)initWithWinner:(field_t)winner orientation:(orientation)orientation startField:(int)startField
{
    self = [super init];
    if(self){
        self.winner = winner;
        self.orientation = orientation;
        self.startField = startField;
    }
    return self;
}

-(NSString*) winner2String
{
    switch (self.winner) {
        case nobody:
            return @"Nobody";
        case player1:
            return @"Player 1";
        case player2:
            return @"Player 2";
        case machine:
            return @"CPU";
    }
}

@end
