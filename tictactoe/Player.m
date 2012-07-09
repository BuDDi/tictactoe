//
//  Player.m
//  tictactoe
//
//  Created by Steffen Buder on 18.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

@implementation Player

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;
@synthesize status = _status;
@synthesize playerID = _playerID;

-(id) initWithTitle:(NSString*) title status:(Status) status coordinate:(CLLocationCoordinate2D)coordinate playerID:(NSString *)playerID
{
    self = [super init];
    if(self) {
        _title = [title copy];
        _subtitle = status == available ? @"Available" : @"Busy";
        _coordinate = coordinate;
        _status = status;
        _playerID = [playerID copy];
    }
    return self;
}

@end
