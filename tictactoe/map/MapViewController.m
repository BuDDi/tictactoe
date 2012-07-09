//
//  MapViewController.m
//  tictactoe
//
//  Created by Steffen Buder on 14.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "GameServerProxy.h"

#define SERVER_URL @"www.czichos.net"
#define SERVER_PORT 8080


@interface MapViewController ()
@property (nonatomic, retain) CLLocationManager* manager;
@end

@implementation MapViewController
{
    GameServerProxy* server;
}
@synthesize titleItem = _titleItem;
@synthesize mapView = _mapView;
@synthesize player = _player;
@synthesize manager = _manager;
//@synthesize players = _players;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Map";
        self.tabBarItem = [[UITabBarItem alloc]
                                         initWithTitle:NSLocalizedString(@"Map", @"MapTabTitle")
                                         image:[UIImage imageNamed:@"map.png"]
                                         tag:1];
        self.titleItem.title = @"Map";
        //self.players = [[NSMutableArray alloc] init];
        self.manager = [[[CLLocationManager alloc] init] autorelease];
        self.manager.delegate = self;
        server = [[GameServerProxy alloc] initWithDelegate:self];
        [server connectToServer:SERVER_URL Port:SERVER_PORT];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // hier Anmeldung am Server vollziehen
    //[server login];
    [self showPlayer];
    [self.manager startUpdatingLocation];
}

- (void)viewDidUnload
{
    [self setTitleItem:nil];
    [self setMapView:nil];
    [self setPlayer:nil];
    //[self setPlayers:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) showPlayer {
    
    [server peers];
    
//    CLLocationCoordinate2D coordinate;
//    coordinate.latitude = 52.543275;
//    coordinate.longitude = 13.352991;
//    
//    self.mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000);
    
    
    
    //
    // Set 10 random locations on the map for testing purposes
    //
//    for(int i = 0; i < 10; i++)
//    {
//        NSString* name = [NSString stringWithFormat:@"Player%d", i];
//        CGFloat latDelta = rand()*.035/RAND_MAX -.02;
//        CGFloat longDelta = rand()*.03/RAND_MAX -.015;
//        
//        CLLocationCoordinate2D newCoord = { coordinate.latitude + latDelta, coordinate.longitude + longDelta };
//        Player* annotation = [[Player alloc] initWithTitle:name subtitle:@"" status:available coordinate:newCoord];
//        //[annotation setCoordinate: newCoord];
//        [self.mapView addAnnotation:annotation];
//        //[annotation release];
//    }
}

- (void) initPlayerList:(NSDictionary *)playerList
{
    if (self.mapView.annotations.count > 0) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    NSMutableArray* players = [[[NSMutableArray alloc] init] autorelease];
    NSLog(@"got some data");
    NSDictionary* users = [playerList valueForKey:@"users"];
    for (NSDictionary* user in users) {
        NSLog(@"user: %@", user);
        NSString* userID = [user valueForKey:@"id"];
        NSString* name = [user valueForKey:@"nickname"];
        NSString* status = [user valueForKey:@"status"];
        double lat = [[user valueForKey:@"lat"] doubleValue];
        double lon = [[user valueForKey:@"lon"] doubleValue];
        Status stat = [status isEqualToString:@"AVAIL"] || !status ? available : busy;
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lon);
        if (userID && name && stat && lat && lon) {
            Player* player = [[Player alloc] initWithTitle:name status:stat coordinate:coord playerID:userID];
            [players addObject:player];
        }
    }
    
//    if (self.mapView.showsUserLocation) {
//        CLLocationCoordinate2D coordinate;
//        coordinate.latitude = self.mapView.userLocation.location.coordinate.latitude;
//        coordinate.longitude = self.mapView.userLocation.location.coordinate.longitude;
//        self.mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000);
//    }

    for (Player* player in players) {
        [self.mapView addAnnotation:player];
    }
    
    if ([self.mapView.annotations count] == 0) return; 
    
    CLLocationCoordinate2D topLeftCoord; 
    topLeftCoord.latitude = -90; 
    topLeftCoord.longitude = 180; 
    
    CLLocationCoordinate2D bottomRightCoord; 
    bottomRightCoord.latitude = 90; 
    bottomRightCoord.longitude = -180; 
    
    for(id<MKAnnotation> annotation in self.mapView.annotations) { 
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude); 
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude); 
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude); 
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude); 
    } 
    
    MKCoordinateRegion region; 
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5; 
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;      
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; 
    
    // Add a little extra space on the sides 
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; 
    
    region = [self.mapView regionThatFits:region]; 
    [self.mapView setRegion:region animated:YES];
}

-(void) invitePlayer:(UIButton*) sender
{
    Player* player = [self.mapView.annotations objectAtIndex:sender.tag];
    if (player.status == available) {
        [server invitePlayer:player];
    }
}

-(void) handleInvitationAnswer:(NSDictionary *)invitation
{
    NSLog(@"got invitation answer %@", invitation);
    NSString* playerName = [invitation valueForKey:@"inviteeID"];
    BOOL accepted = [[invitation valueForKey:@"inviteeID"] boolValue];
    NSString* message = nil;
    UIAlertView* alertView = nil;
    if (accepted) {
        message = [NSString stringWithFormat:@"%@ wants to play with you.", playerName];
    } else {
        message = [NSString stringWithFormat:@"%@ does not want to play with you.", playerName];
    }
    alertView = [[UIAlertView alloc] initWithTitle:@"Invitation" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (Player*) getPlayerForID:(NSString*) playerID
{
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if([annotation isKindOfClass:[Player class]]){
            Player* player = annotation;
            if ([player.playerID isEqualToString:playerID]) {
                return player;
            } 
        }
    }
    return nil;
}

Player* latestInvitee = nil;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"ok pressed");
        if (latestInvitee) {
            // Einladungsanfrage
            [server answerInvitation:latestInvitee answer:YES];
        }
    } else {
        NSLog(@"cancel pressed");
        if (latestInvitee) {
            // Einladungsanfrage
            [server answerInvitation:latestInvitee answer:NO];
        }
    }
    latestInvitee = nil;
}

-(void) handleInvitation:(NSDictionary *)invitation
{
    NSLog(@"got invitation %@", invitation);
    NSLog(@"got invitation answer %@", invitation);
    NSString* playerName = [invitation valueForKey:@"inviterName"];
    NSString* playerID = [invitation valueForKey:@"inviterID"];
    //BOOL accepted = NO;
    //NSString* message = nil;
    //alertView = nil;
    NSString* message = [NSString stringWithFormat:@"%@ wants to play with you.", playerName];
    latestInvitee = [self getPlayerForID:playerID];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Invitation" message:message delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alertView show];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString* annoIdentifier = @"player";
    
    MKPinAnnotationView* pinView = nil;
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return pinView;
    }
    
    pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:annoIdentifier];
    if (!pinView) {
        pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annoIdentifier] autorelease];
    }else {
        pinView.annotation = annotation;
    }
    [self configureAnnoView:pinView forAnnotation:annotation];
    return pinView;
}

-(void) configureAnnoView:(MKPinAnnotationView*) annoView forAnnotation:(id <MKAnnotation>) annotation
{
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //[rightButton setImage:image forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(invitePlayer:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTag: [_mapView.annotations indexOfObject:annotation]];

    Player* player = annotation;
    if(player.status==available){
        annoView.pinColor = MKPinAnnotationColorGreen;
        annoView.rightCalloutAccessoryView = rightButton;
    } else {
        annoView.pinColor = MKPinAnnotationColorRed;
        annoView.rightCalloutAccessoryView = nil;
    }
    annoView.animatesDrop = true;
    annoView.canShowCallout = true;
    // TODO button und icon noch hinzufügen
    
    UIImageView* leftIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game.png"]];
    annoView.leftCalloutAccessoryView = leftIconView;
    //annoView.image = image;
    //[rightButton setImage:image forState:UIControlStateNormal];
    
    //NSString* keyString = [NSNumber numberWithInteger:[[rightButton hash] stringValue]];
    
}

- (IBAction)refresh:(UIBarButtonItem *)sender
{
    [self showPlayer];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [server updateLocation:newLocation];
}

- (void)dealloc {
    [_titleItem release];
    [_mapView release];
    [super dealloc];
}

@end
