//
//  TicTacToeMatrix.h
//  tictactoe
//
//  Created by Steffen Buder on 14.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    nobody,
    player1,
    player2,
    machine
} field_t;

@interface TicTacToeMatrix : NSObject


@property (nonatomic) int numPlayer;

-(void) reset;
-(void) setValue:(field_t)value atX:(int)x andY:(int)y;
@end
