//
//  SettingsViewController.m
//  tictactoe
//
//  Created by Steffen Buder on 14.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "SettingsViewController.h"
#import "WinNotificationObject.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
{
    bool gameStarted;
}
@synthesize gameModeSwitch = _gameModeSwitch;
@synthesize crossSelectButton = _crossSelectButton;
@synthesize circleSelectButton = _circleSelectButton;
@synthesize startingPlayerSwitch = _startingPlayerSwitch;
@synthesize gameServerField = _gameServerField;
@synthesize nicknameField = _nicknameField;
@synthesize model = _model;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Settings";
        self.tabBarItem = [[UITabBarItem alloc]
                           initWithTitle:NSLocalizedString(@"Settings", @"SettingsTabTitle")
                           image:[UIImage imageNamed:@"settings.png"]
                           tag:2];
        
        _model = [[SettingsModel alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameStarted:) name:@"startGame" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameEnded:) name:@"endGame" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

-(void) initView
{
    if (gameStarted) {
        [self disableAllInputs];
    }else {
        [self enableAllInputs];
    }
}

- (void)viewDidUnload
{
    [self setStartingPlayerSwitch:nil];
    [self setCrossSelectButton:nil];
    [self setCircleSelectButton:nil];
    [self setGameModeSwitch:nil];
    [self setModel: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setGameServerField:nil];
    [self setNicknameField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_startingPlayerSwitch release];
    [_crossSelectButton release];
    [_circleSelectButton release];
    [_gameModeSwitch release];
    [_model release];
    [_gameServerField release];
    [_nicknameField release];
    [super dealloc];
}
- (IBAction)setGameMode:(UISegmentedControl *)sender {
    bool singlePlayer = [sender selectedSegmentIndex] == 0;
    if(!singlePlayer){
        [_startingPlayerSwitch setTitle:@"Player 1" forSegmentAtIndex:0];
        [_startingPlayerSwitch setTitle:@"Player 2" forSegmentAtIndex:1];
    }else {
        [_startingPlayerSwitch setTitle:@"User" forSegmentAtIndex:0];
        [_startingPlayerSwitch setTitle:@"CPU" forSegmentAtIndex:1];
    }
    [_model setNumPlayer: [sender selectedSegmentIndex] + 1];
}

- (IBAction)setMyImage:(UIButton *)sender {
    if (sender.tag == 0) {
        [self.model setPlayer1Image: [UIImage imageNamed:@"kreuz.png"]];
        [self.model setPlayer1WinImage:[UIImage imageNamed:@"kreuz_win.png"]];
        [self.model setPlayer2Image:[UIImage imageNamed:@"kreis.png"]];
        [self.model setPlayer2WinImage:[UIImage imageNamed:@"kreis_win.png"]];
        [sender setImage: [self.model player1WinImage]  forState:UIControlStateNormal];
        [sender setImage: [self.model player1WinImage]  forState:UIControlStateHighlighted];
        [_circleSelectButton setImage:[self.model player2Image] forState:UIControlStateNormal];
        [_circleSelectButton setImage:[self.model player2Image] forState:UIControlStateHighlighted];
    }else{
        [self.model setPlayer1Image: [UIImage imageNamed:@"kreis.png"]];
        [self.model setPlayer1WinImage:[UIImage imageNamed:@"kreis_win.png"]];
        [self.model setPlayer2Image:[UIImage imageNamed:@"kreuz.png"]];
        [self.model setPlayer2WinImage:[UIImage imageNamed:@"kreuz_win.png"]];
        [sender setImage: [self.model player1WinImage]  forState:UIControlStateNormal];
        [sender setImage: [self.model player1WinImage]  forState:UIControlStateHighlighted];
        [_crossSelectButton setImage:[self.model player2Image] forState:UIControlStateNormal];
        [_crossSelectButton setImage:[self.model player2Image] forState:UIControlStateHighlighted];
    }
}

- (IBAction)setStartingPlayer:(UISegmentedControl *)sender {
    [self.model setAmIStarting:[sender selectedSegmentIndex] == 0];
}

- (IBAction)setGameServerAdress:(UITextField *)sender {
    [self.model setGameServerAdress: sender.text];
}

- (IBAction)setNickName:(UITextField *)sender {
    [self.model setNickname: sender.text];
}

- (void) gameStarted: (WinNotificationObject*) object{
    gameStarted = YES;
    [self.model setNumPlayer:[_gameModeSwitch selectedSegmentIndex] + 1];
    [self disableAllInputs];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applySettings" object:self.model]; 
}

- (void) gameEnded: (WinNotificationObject*) object{
    gameStarted = NO;
    [self enableAllInputs];
}

-(void) disableAllInputs
{
    [self.gameModeSwitch setEnabled:NO];
    [self.crossSelectButton setEnabled:NO];
    [self.circleSelectButton setEnabled:NO];
    [self.startingPlayerSwitch setEnabled:NO];
    [self.gameServerField setEnabled:NO];
    [self.nicknameField setEnabled:NO];
}

-(void) enableAllInputs
{
    [self.gameModeSwitch setEnabled:YES];
    [self.crossSelectButton setEnabled:YES];
    [self.circleSelectButton setEnabled:YES];
    [self.startingPlayerSwitch setEnabled:YES];
    [self.gameServerField setEnabled:YES];
    [self.nicknameField setEnabled:YES];
}
@end
