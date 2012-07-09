//
//  Player.h
//  tictactoe
//
//  Created by Steffen Buder on 18.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

typedef enum {busy, available} Status;

@interface Player : NSObject <MKAnnotation>

@property (nonatomic) Status status;
@property (nonatomic, retain) NSString* playerID;

-(id) initWithTitle:(NSString*) title status:(Status) status coordinate:(CLLocationCoordinate2D)coordinate playerID:(NSString*)playerID;

@end
