//
//  SetFieldObject.h
//  tictactoe
//
//  Created by Steffen Buder on 21.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetFieldObject : NSObject

@property (nonatomic) int x;
@property (nonatomic) int y;

-(id) initWithX: (int)x andY:(int)y;

@end
