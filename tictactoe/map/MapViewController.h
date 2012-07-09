//
//  MapViewController.h
//  tictactoe
//
//  Created by Steffen Buder on 14.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "Player.h"
#import "GameServerDelegate.h"

@interface MapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate, GameServerDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UINavigationItem *titleItem;

@property (retain, nonatomic) IBOutlet MKMapView *mapView;

@property (retain, nonatomic) Player* player;

- (IBAction)refresh:(UIBarButtonItem *)sender;

//@property (strong, nonatomic) NSMutableArray* players;


@end
