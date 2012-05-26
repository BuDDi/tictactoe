//
//  SetFieldObject.m
//  tictactoe
//
//  Created by Steffen Buder on 21.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetFieldObject.h"

@implementation SetFieldObject

@synthesize x = _x;
@synthesize y = _y;

-(id) initWithX: (int)x andY:(int)y
{
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
    }
    return self;
}

@end
