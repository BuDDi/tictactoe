//
//  GameServerDelegate.h
//  tictactoe
//
//  Created by Steffen Buder on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameServerDelegate <NSObject>

@required
-(void) initPlayerList:(NSDictionary*) playerList;
-(void) handleInvitationAnswer:(NSDictionary*) invitation;
-(void) handleInvitation:(NSDictionary*) invitation;

@end
