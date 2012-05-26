//
//  ViewController.m
//  tictactoe
//
//  Created by Steffen Buder on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "TicTacToeMatrix.h"
#import "GameViewController.h"
#import "WinNotificationObject.h"
#import "SetFieldObject.h"

@interface GameViewController ()

@end

@implementation GameViewController
{
    TicTacToeMatrix* model;
    int roundCounter;
    BOOL startedGame;
}
@synthesize b1 = _b1;
@synthesize b2 = _b2;
@synthesize b3 = _b3;
@synthesize b4 = _b4;
@synthesize b5 = _b5;
@synthesize b6 = _b6;
@synthesize b7 = _b7;
@synthesize b8 = _b8;
@synthesize b9 = _b9;
@synthesize kreis = _kreis;
@synthesize kreuz = _kreuz;
@synthesize label1 = _label1;
@synthesize playerSwitch = _playerSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Game";
        self.tabBarItem = [[UITabBarItem alloc]
                           initWithTitle:NSLocalizedString(@"Game", @"GameTabTitle")
                           image:[UIImage imageNamed:@"game.png"]
                           tag:0];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    roundCounter = 0;
    self.kreis = [UIImage imageNamed:@"kreis.png"];
    self.kreuz = [UIImage imageNamed:@"kreuz.png"];
    model = [[TicTacToeMatrix alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finalizeGame:) name:@"winner" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelSetFieldAuto:) name:@"setfield" object:nil];
    [self setNumPlayer];
}

- (void)viewDidUnload
{
    [self setB1:nil];
    [self setB2:nil];
    [self setB3:nil];
    [self setB4:nil];
    [self setB5:nil];
    [self setB6:nil];
    [self setB7:nil];
    [self setB8:nil];
    [self setB9:nil];
    [self setLabel1:nil];
    self.kreis = nil;
    self.kreuz = nil;
    self.playerSwitch = nil;
    model = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [self.b1 release];
    [self.b2 release];
    [self.b3 release];
    [self.b4 release];
    [self.b5 release];
    [self.b6 release];
    [self.b7 release];
    [self.b8 release];
    [self.b9 release];
    [self.label1 release];
    [self.kreis release];
    [self.kreuz release];
    [self.playerSwitch release];
    [model release];
    [super dealloc];
}

- (void) clearDisplay{
    [self.b1 setImage:nil forState:UIControlStateNormal];
    [self.b1 setImage:nil forState:UIControlStateHighlighted];
    [self.b2 setImage:NULL forState:UIControlStateNormal];
    [self.b2 setImage:NULL forState:UIControlStateHighlighted];
    [self.b3 setImage:nil forState:UIControlStateNormal];
    [self.b3 setImage:nil forState:UIControlStateHighlighted];
    [self.b4 setImage:nil forState:UIControlStateNormal];
    [self.b4 setImage:nil forState:UIControlStateHighlighted];
    [self.b5 setImage:nil forState:UIControlStateNormal];
    [self.b5 setImage:nil forState:UIControlStateHighlighted];
    [self.b6 setImage:nil forState:UIControlStateNormal];
    [self.b6 setImage:nil forState:UIControlStateHighlighted];
    [self.b7 setImage:nil forState:UIControlStateNormal];
    [self.b7 setImage:nil forState:UIControlStateHighlighted];
    [self.b8 setImage:nil forState:UIControlStateNormal];
    [self.b8 setImage:nil forState:UIControlStateHighlighted];
    [self.b9 setImage:nil forState:UIControlStateNormal];
    [self.b9 setImage:nil forState:UIControlStateHighlighted];
    
    self.b1.imageView.image = nil;
    self.b2.imageView.image = nil;
    self.b3.imageView.image = nil;
    self.b4.imageView.image = nil;
    self.b5.imageView.image = nil;
    self.b6.imageView.image = nil;
    self.b7.imageView.image = nil;    
    self.b8.imageView.image = nil;
    self.b9.imageView.image = nil;
    
}

- (void) reset {
    [model reset];
    [self clearDisplay];
    [self enableButtons];
    self.label1.text = @"";
    roundCounter = 0;
    startedGame = true;
    [self.playerSwitch setEnabled:NO];
    [self setNumPlayer];
}

-(void) enableButtons
{
    [self.b1 setEnabled:YES];
    [self.b2 setEnabled:YES];
    [self.b3 setEnabled:YES];
    [self.b4 setEnabled:YES];
    [self.b5 setEnabled:YES];
    [self.b6 setEnabled:YES];
    [self.b7 setEnabled:YES];    
    [self.b8 setEnabled:YES];
    [self.b9 setEnabled:YES];
}

- (IBAction)startAction:(id)sender {
    [self reset];
}

- (IBAction)setImage:(id)sender {
    if (startedGame) {
        int tag = [sender tag];
        field_t val = roundCounter % 2 == 0 ? player1 : player2;
        UIImage* image = roundCounter % 2 == 0 ? self.kreis : self.kreuz;
        
        [sender setImage:image forState:UIControlStateNormal];
        [sender setImage:image forState:UIControlStateHighlighted];
        [sender setEnabled:NO];
        [model setValue:val atX:tag%3 andY:tag/3];
        roundCounter++;
    }
}

- (void) finalizeGame:(NSNotification*) note{
    //NSLog(@"Got notified: %@", note);
    //NSLog(@"Got notified2: %@ %@", note.object, [note.object respondsToSelector:@selector(winner)]);
    startedGame = false;
    [self.playerSwitch setEnabled:YES];
    
    if ([note object]) {
        WinNotificationObject* winObj = note.object;
        self.label1.text = [NSString stringWithFormat:@"%@ %@", @"Game over, Winner:", [winObj winner2String]];
        switch ([winObj orientation]) {
            case horizontal:
                [self paintButtonsAtHorLine:winObj.startField withImage: [self getImageForWinner:winObj.winner]];
                break;
            case vertical:
                [self paintButtonsAtVertLine:winObj.startField withImage: [self getImageForWinner:winObj.winner]];
                break;
            case diagonal:
                [self paintButtonsAtDiagLine:winObj.startField withImage: [self getImageForWinner:winObj.winner]];
                break;
        }
        // not needed any longer
        [winObj release];
    }else {
        self.label1.text = @"Game over, no Winner";
    }
    
}

- (IBAction)setPlayer:(id)sender
{
    [self setNumPlayer];  
}

- (void) setNumPlayer
{
    int selectedIndex = self.playerSwitch.selectedSegmentIndex;
    [model setNumPlayer:selectedIndex + 1];
}

- (void) paintButtonsAtHorLine:(int) y withImage:(UIImage*) image{
    
    for (int x=0; x<3; x++) {
        int button = (y * 3) + x;
        UIButton* uiButton = [self getButton: button];
        [uiButton setImage:image forState:UIControlStateNormal];
        [uiButton setImage:image forState:UIControlStateHighlighted];
    }
}
- (void) paintButtonsAtVertLine:(int) x withImage:(UIImage*) image{
    for (int y=0; y<3; y++) {
        int button = x + (y * 3);
        UIButton* uiButton = [self getButton: button];
        [uiButton setImage:image forState:UIControlStateNormal];
        [uiButton setImage:image forState:UIControlStateHighlighted];
    }
}

- (void) modelSetFieldAuto:(NSNotification*) note
{
    SetFieldObject* fieldObj = [note object];
    //NSLog(@"SetFieldAuto x:%d y:%d", fieldObj.x, fieldObj.y);
    int buttonIndex = (fieldObj.y * 3) + fieldObj.x;
    UIButton* button = [self getButton:buttonIndex];
    [button setImage:self.kreuz forState:UIControlStateNormal];
    [button setImage:self.kreuz forState:UIControlStateHighlighted];
    [button setEnabled:NO];
    roundCounter++;
    // not needed any longer
    [fieldObj release];
}
- (void) paintButtonsAtDiagLine:(int) x withImage:(UIImage*) image
{
    if(x==0){
        [self.b1 setImage:image forState:UIControlStateNormal];
        [self.b1 setImage:image forState:UIControlStateHighlighted];
        [self.b5 setImage:image forState:UIControlStateNormal];
        [self.b5 setImage:image forState:UIControlStateHighlighted];
        [self.b9 setImage:image forState:UIControlStateNormal];
        [self.b9 setImage:image forState:UIControlStateHighlighted];
    }else{
        [self.b3 setImage:image forState:UIControlStateNormal];
        [self.b3 setImage:image forState:UIControlStateHighlighted];
        [self.b5 setImage:image forState:UIControlStateNormal];
        [self.b5 setImage:image forState:UIControlStateHighlighted];
        [self.b7 setImage:image forState:UIControlStateNormal];
        [self.b7 setImage:image forState:UIControlStateHighlighted];
    }
}

- (UIButton*) getButton: (int) i
{
    switch (i) {
        case 0:
            return self.b1;
        case 1:
            return self.b2;
        case 2:
            return self.b3;
        case 3:
            return self.b4;
        case 4:
            return self.b5;
        case 5:
            return self.b6;
        case 6:
            return self.b7;
        case 7:
            return self.b8;
        case 8:
            return self.b9;
        default:
            return nil;
    }
}

-(UIImage*) getImageForWinner:(field_t) winner
{
    switch (winner) {
        case player1:
            return [UIImage imageNamed:@"kreis_win.png"];
        case player2:
        case machine:
            return [UIImage imageNamed:@"kreuz_win.png"];
        default:
            return nil;
    }
}

@end
