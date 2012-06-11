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

-(void) reset;
-(void) setValueatX:(int)x andY:(int)y;
- (void)setNumPlayer:(int)object;
-(void)setPlayer1Starts:(BOOL)player1Starts;
-(int) roundCounter;
@end
