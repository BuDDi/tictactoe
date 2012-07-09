//
//  GameServerProxy.h
//  tictactoe
//
//  Created by Steffen Buder on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameServerDelegate.h"
#import "Player.h"

@interface GameServerProxy : NSObject <NSStreamDelegate> {
    BOOL _inputConnected;
    BOOL _outputConnected;
}

@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;
@property (readonly) BOOL connected;

@property (nonatomic, retain) NSString *myID;

@property (nonatomic, retain) id<GameServerDelegate> delegate; 

- (id) initWithDelegate:(id<GameServerDelegate>) delegate;
- (void)connectToServer:(NSString*)host Port:(NSInteger)port;

- (BOOL) connected;
- (void) peers;

- (void) invitePlayer:(Player*) player;
- (void) answerInvitation:(Player*) inviter answer:(BOOL) answer;
- (void) updateLocation:(CLLocation*) newLocation;
@end