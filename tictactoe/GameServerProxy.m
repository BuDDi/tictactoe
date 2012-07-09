#import "GameServerProxy.h"
#import "AppDelegate.h"

@interface GameServerProxy ()
- (void) login;
- (void) processData;
@end

@implementation GameServerProxy

@synthesize inputStream = _inputStream;
@synthesize outputStream = _outputStream;

@synthesize delegate = _delegate;
@synthesize myID = _myID;

- (id) init {
    self = [super self];
    if(self) {
        _inputConnected = FALSE;
        _outputConnected = FALSE;
    }
    return self;
}

- (id) initWithDelegate:(id<GameServerDelegate>) delegate
{
    self = [super init];
    if (self) {
        _inputConnected = FALSE;
        _outputConnected = FALSE;
        self.delegate = delegate;
    }
    return self;
}

- (BOOL) connected {
    if(_inputConnected && _outputConnected) {
        return TRUE;
    } else {
        return FALSE;
    }
}

- (void) processData {
    uint8_t buffer[1024];
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSInteger length;
    
    while ([self.inputStream hasBytesAvailable]) {
        length = [self.inputStream read:buffer maxLength:sizeof(buffer)];
        if (length > 0) {
            [data appendBytes:buffer length:length];
        }
    }
    NSError *error = nil;
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
    
    NSString *msg = [JSON valueForKey:@"msg"];
    
    if (error == NULL) {
        if ([msg isEqualToString:@"loginInfo"]) {
            self.myID = [JSON valueForKey:@"id"];;
        } else if([msg isEqualToString:@"userlist"]) {
            NSLog(@"%@",JSON);
            NSMutableArray* users = [JSON valueForKey:@"users"];
            for (NSDictionary* user in users) {
                NSString* userID = [user valueForKey:@"id"];
                if ([userID isEqualToString:self.myID]) {
                    [users removeObject:user];
                    break;
                }
            }
            [_delegate initPlayerList:JSON];
        } else if([msg isEqualToString:@"inviteAnswer"]){
            [self.delegate handleInvitationAnswer:JSON];
        } else if([msg isEqualToString:@"invite"]){
            [self.delegate handleInvitation:JSON];
        }
    }
}

- (void)connectToServer:(NSString*)host Port:(NSInteger)port {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)host, port, &readStream, &writeStream);
    self.inputStream = (NSInputStream *)readStream;
    self.outputStream = (NSOutputStream *)writeStream;
    
    [self.inputStream setDelegate:self];
    [self.outputStream setDelegate:self];
    
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.inputStream open];
    [self.outputStream open];
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
	switch (streamEvent) {
            
		case NSStreamEventOpenCompleted:
            if(theStream == _inputStream) {
                NSLog(@"InputStream connected");
                _inputConnected = TRUE;
            }
            if(theStream == _outputStream) {
                NSLog(@"OutputStream connected");
                _outputConnected = TRUE;
            }
            if(self.connected) {
                [self performSelector:@selector(login) withObject:self afterDelay:0.0];
            }
			break;
            
		case NSStreamEventHasBytesAvailable:
			NSLog(@"NSStreamEventHasBytesAvailable");
            [self processData];
			break;			
            
		case NSStreamEventErrorOccurred:
			NSLog(@"NSStreamEventErrorOccurred");
			break;
            
		case NSStreamEventEndEncountered:
			NSLog(@"NSStreamEventEndEncountered");
			break;
            
		default:
			NSLog(@"Unknown event");
	}    
}

- (void) login {
    //    NSString *request = @"msg=login;nickname=Niccy";
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSString* nickname = appDelegate.settingsViewController.model.nickname;
    
    NSString *request = [NSString stringWithFormat:@"msg=login;name=%@;status=avail", nickname];
    
    if(self.connected) {
        NSInteger length = request.length;
        [self.outputStream write:[request UTF8String] maxLength:length];
        
    }
}

- (void) peers {
    NSString *request = @"msg=userlist";
    
    if(self.connected) {
        NSInteger length = request.length;
        [self.outputStream write:[request UTF8String] maxLength:length];
        
    }
}

- (void) invitePlayer:(Player*) player
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSString* nickname = appDelegate.settingsViewController.model.nickname;
    NSLog(@"msg=invite;inviterID=%@;inviterName=%@;inviteeID=%@;info=text", self.myID, nickname, player.playerID);
    NSString* request = [NSString stringWithFormat:@"msg=invite;inviterID=%@;inviterName=%@;inviteeID=%@;info=TEXT", self.myID, nickname, player.playerID];
    if (self.connected) {
        NSInteger length = request.length;
        [self.outputStream write:[request UTF8String] maxLength:length];
    }
}

- (void) answerInvitation:(Player*) inviter answer:(BOOL) answer
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSString* nickname = appDelegate.settingsViewController.model.nickname;
    NSString* answerStr = answer ? [NSString stringWithFormat:@"yes"] : [NSString stringWithFormat:@"no"];
    // TODO hier noch yourTurn richtig ermitteln
    NSString* yourTurn = [NSString stringWithFormat:@"yes"];
    NSString* request = [NSString stringWithFormat:@"msg=inviteAnswer;inviterID=%@;inviteeID=%@;inviteeName=%@;accept=%@;yourTurn=%@;info=text", inviter.playerID, self.myID, nickname, answerStr, yourTurn];
    if (self.connected) {
        NSInteger length = request.length;
        [self.outputStream write:[request UTF8String] maxLength:length];
    }
}

- (void) updateLocation:(CLLocation*) newLocation
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSString* nickname = appDelegate.settingsViewController.model.nickname;
    NSString* request = [NSString stringWithFormat:@"msg=position;nickname=%@;lat=%f;lon=%f;status=AVAIL", nickname, newLocation.coordinate.latitude, newLocation.coordinate.longitude];
    if (self.connected) {
        NSInteger length = request.length;
        [self.outputStream write:[request UTF8String] maxLength:length];
    }
}

@end
