//
//  WinNotificationObject.h
//  tictactoe
//
//  Created by Steffen Buder on 21.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "TicTacToeMatrix.h"
#import <Foundation/Foundation.h>

typedef enum {
    horizontal,
    vertical,
    diagonal
} orientation;

@interface WinNotificationObject : NSObject

@property (nonatomic) orientation orientation;
@property (nonatomic) field_t winner;
@property (nonatomic) int startField;

-(id)initWithWinner:(field_t)winner orientation:(orientation)orientation startField:(int)startField;
-(NSString*) winner2String;
@end
