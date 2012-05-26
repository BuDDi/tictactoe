//
//  TicTacToeMatrix.m
//  tictactoe
//
//  Created by Steffen Buder on 14.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TicTacToeMatrix.h"
#import "WinNotificationObject.h"
#import "SetFieldObject.h"

@implementation TicTacToeMatrix
{
    field_t fields[3][3];
}

@synthesize numPlayer = _numPlayer;

- (void) reset {
    for (int y=0; y<3; y++) {
        for (int x=0; x<3; x++) {
            fields[y][x] = nobody;
        }
    }
}

-(void) setValue:(field_t)value atX:(int)x andY:(int)y
{
    NSLog(@"x:%d, y:%d, val:%d", x, y, value);
    
    fields[y][x] = value;
    BOOL gameOver = [self checkState];
    if(self.numPlayer == 1 && !gameOver){
        [self setValueAuto];
        [self checkState];
    }
}

-(void) setValueAuto
{
    // Strategie: erst nach Linien schauen, die der Gegner fast fertig hat (Verteidigung)
    // Wenn kein Verteidigungspunkt geliefert wird, dann Angriff
    // Angriff schaut erst nach freien Ecken
    SetFieldObject* field = [self getDefenseField];
    if(!field){
        field = [self getOffenseField];
        if (!field) {
            field = [self getAnyCornerOrMiddleField];
            if (!field){
                field = [self getAnyField];
            }
        }
    }
    fields[field.y][field.x] = machine;
    [self notifySetAutoField: field];
}

- (SetFieldObject*) getDefenseField
{
    SetFieldObject* erg = nil;
    for (int i=0; i<3; i++){
        // Zeile, die an den Ecken von Player 1 besetzt ist
        if(fields[i][0] == player1 && fields[i][1] == nobody && fields[i][2] == player1){
            erg = [[SetFieldObject alloc] initWithX:1 andY:i];
            return erg;
        }
        // Zeile, die zwei Player 1 Felder nebeneinander hat
        if(fields[i][0] == player1 && fields[i][1] == player1 && fields[i][2] == nobody){
            erg = [[SetFieldObject alloc] initWithX:2 andY:i];
            return erg;
        }
        // Zeile, die zwei Player 1 Felder nebeneinander hat
        if(fields[i][1] == player1 && fields[i][2] == player1 && fields[i][0] == nobody){
            erg = [[SetFieldObject alloc] initWithX:0 andY:i];
            return erg;
        }
        // Spalte, die an den Ecken von Player 1 besetzt ist
        if(fields[0][i] == player1 && fields[2][i] == player1 && fields[1][i] == nobody){
            erg = [[SetFieldObject alloc] initWithX:i andY:1];
        }
        // Spalte, die zwei Player 1 Felder nebeneinander hat
        if(fields[0][i] == player1 && fields[1][i] == player1 && fields[2][i] == nobody){
            erg = [[SetFieldObject alloc] initWithX:i andY:2];
            return erg;
        }
        // Spalte, die zwei Player 1 Felder nebeneinander hat
        if(fields[1][i] == player1 && fields[2][i] == player1 && fields[0][i] == nobody){
            erg = [[SetFieldObject alloc] initWithX:i andY:0];
            return erg;
        }
    }
    // diagonale Felder überprüfen
    if (fields[0][0] == player1 && fields[1][1] == player1 && fields[2][2] == nobody) {
        erg = [[SetFieldObject alloc] initWithX:2 andY:2];
        return erg;
    } 
    if (fields[1][1] == player1 && fields[2][2] == player1 && fields[0][0] == nobody){
        erg = [[SetFieldObject alloc] initWithX:0 andY:0];
        return erg;
    }
    if ((fields[0][0] == player1 && fields[2][2] == player1 && fields[1][1] == nobody)
        || (fields[0][2] == player1 && fields[2][0] == player1 && fields[1][1] == nobody)){
        erg = [[SetFieldObject alloc] initWithX:1 andY:1];
        return erg;
    }
    if (fields[0][2] == player1 && fields[1][1] == player1 && fields[2][0] == nobody) {
        erg = [[SetFieldObject alloc] initWithX:0 andY:2];
        return erg;
    }
    if (fields[2][0] == player1 && fields[1][1] == player1 && fields[0][2] == nobody){
        erg = [[SetFieldObject alloc] initWithX:2 andY:0];
        return erg;
    }
    return erg;
}

- (SetFieldObject*) getOffenseField
{
    // Mögliche Erweiterung -> Liste von Punkten zusammenstellen und dann zufällig daraus wählen
    SetFieldObject* erg = nil;
    // Erstens überprüfen, ob KI selber gewinnen kann
    for (int i=0; i<3; i++) {
        // Zeile
        // sind 2 direkt nebeneinander setze den dritten und gewinne
        if (fields[i][0] == machine && fields[i][1] == machine && fields[i][2]== nobody){
            erg = [[SetFieldObject alloc] initWithX:2 andY:i];
            return erg;
        }
        // anderer Fall
        if(fields[i][1] == machine && fields[i][2] == machine && fields[i][0] == nobody){
            erg = [[SetFieldObject alloc] initWithX:0 andY:i];
            return erg;
        }
        // gibt es in einer Zeile eine Lücke aber trotzdem 2 der KI setze den dritten und gewinne
        if (fields[i][0] == machine && fields[i][2] == machine && fields[i][1] == nobody) {
            erg = [[SetFieldObject alloc] initWithX:1 andY:i];
            return erg;
        }
        // Spalte (selbes Verfahren wie Zeile; 2 direkt nebeneinander und Lücke)
        if (fields[0][i] == machine && fields[1][i] == machine && fields[2][i] == nobody){
            erg = [[SetFieldObject alloc] initWithX:i andY:2];
            return erg;
        }
        if (fields[2][i] == machine && fields[1][i] == machine && fields[0][i] == nobody) {
            erg = [[SetFieldObject alloc] initWithX:i andY:0];
            return erg;
        }
        if (fields[0][i] == machine && fields[2][i] == machine && fields[1][i] == nobody) {
            erg = [[SetFieldObject alloc] initWithX:i andY:1];
            return erg;
        }
        // diagonal
        if (i!=1) {
            int counterIndex = i == 0 ? 2 : 0;
            if (fields[0][i] == machine && fields[1][1] == machine && fields[2][counterIndex] == nobody) {
                erg = [[SetFieldObject alloc] initWithX:counterIndex andY:2];
                return erg;
            }
            if (fields[2][counterIndex] == machine && fields[1][1] == machine && fields[0][i] == nobody) {
                erg = [[SetFieldObject alloc] initWithX:i andY:0];
                return erg;
            }
            // Lücke
            if (fields[0][i] == machine && fields[2][counterIndex] == machine && fields[1][1] == nobody) {
                erg = [[SetFieldObject alloc] initWithX:1 andY:1];
                return erg;
            }
        }
    }
    // Zweitens: taktisch kluge Felder finden.
    // Prio1: Lücken erstellen, d.h. es muss eine Zeile geben, in der ein Feld mit KI gesetzt ist,
    // aber kein anderes Feld gesetzt ist
    for (int i=0; i<3; i++) {
        // Zeile
        // Lücke
        if (fields[i][0] == machine && fields[i][1] == nobody && fields[i][2]== nobody){
            erg = [[SetFieldObject alloc] initWithX:2 andY:i];
            return erg;
        }
        // anderer Fall
        if(fields[i][2] == machine && fields[i][0] == nobody && fields[i][1] == nobody){
            erg = [[SetFieldObject alloc] initWithX:0 andY:i];
            return erg;
        }
        // Spalte
        // Lücke
        if (fields[0][i] == machine && fields[1][i] == nobody && fields[2][i]== nobody){
            erg = [[SetFieldObject alloc] initWithX:i andY:2];
            return erg;
        }
        // anderer Fall
        if(fields[2][i] == machine && fields[0][i] == nobody && fields[1][i] == nobody){
            erg = [[SetFieldObject alloc] initWithX:i andY:0];
            return erg;
        }
        // diagonal
        if (i!=1) {
            int counterIndex = i == 0 ? 2 : 0;
            if (fields[0][i] == machine && fields[1][1] == nobody && fields[2][counterIndex] == nobody) {
                erg = [[SetFieldObject alloc] initWithX:counterIndex andY:2];
                return erg;
            }
            if (fields[2][counterIndex] == machine && fields[1][1] == nobody && fields[0][i] == nobody) {
                erg = [[SetFieldObject alloc] initWithX:i andY:0];
                return erg;
            }
        }
    }
    return erg;
}

- (SetFieldObject*) getAnyCornerOrMiddleField
{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    if (fields[0][0] == nobody){
        [arr addObject:[[SetFieldObject alloc] initWithX:0 andY:0]];
    }
    if (fields[0][2] == nobody){
        [arr addObject:[[SetFieldObject alloc] initWithX:2 andY:0]];
    }
    if (fields[2][0] == nobody){
        [arr addObject:[[SetFieldObject alloc] initWithX:0 andY:2]];
    }
    if (fields[2][2] == nobody){
        [arr addObject:[[SetFieldObject alloc] initWithX:2 andY:2]];
    }
    if (fields[1][1] == nobody){
        [arr addObject:[[SetFieldObject alloc] initWithX:1 andY:1]];
    }
    SetFieldObject* erg = nil;
    int arrSize = [arr count];
    if(arrSize > 0){
        int randomIndex = arc4random_uniform(arrSize);
        erg = [arr objectAtIndex:randomIndex];
    }
    [arr release];
    return erg;
}

- (SetFieldObject*) getAnyField
{
    int x, y;
    for (y=0;y<3;y++){
        BOOL found = FALSE;
        for (x=0; x<3; x++) {
            if (fields[y][x]==nobody) {
                found = TRUE;
                break;
            }
        }
        if (found) {
            break;
        }
    }
    return [[SetFieldObject alloc] initWithX:x andY:y];
}

- (BOOL) checkState {    
    // hier Controller benachrichtigen (Ende aber kein Gewinner)
    // Hier Routine übernehmen und Controller benachrichtigen und Gewinner mitliefern
    WinNotificationObject* winObj = nil;
    for(int i=0;i<3;i++){
        // horizontal
        if(fields[i][0]!= nobody && fields[i][0]==fields[i][1] && fields[i][0] == fields[i][2]){
            winObj = [[WinNotificationObject alloc] initWithWinner:fields[i][0] orientation:horizontal startField:i];
            [self notify: winObj];
            return true;
        }
        // vertikal
        if(fields[0][i]!=nobody && fields[0][i]==fields[1][i] && fields[0][i]==fields[2][i]){
            winObj = [[WinNotificationObject alloc] initWithWinner:fields[0][i] orientation:vertical startField:i];
            [self notify: winObj];
            return true;
        }
    }
    // diagonale Faelle
    if(fields[0][0] != nobody && fields[0][0] == fields[1][1] && fields[0][0] == fields[2][2]){
        winObj = [[WinNotificationObject alloc] initWithWinner:fields[0][0] orientation:diagonal startField:0];
        [self notify:winObj];
        return true;
    }else if(fields[0][2] != nobody && fields[0][2] == fields[1][1] && fields[0][2] == fields[2][0]){
        winObj = [[WinNotificationObject alloc] initWithWinner:fields[0][2] orientation:diagonal startField:2];
        [self notify:winObj];
        return true;
    }
    BOOL allSet = true;
    for(int i=0; i<3; i++){
        for (int j=0; j<3; j++) {
            if(fields[i][j] == nobody){
                allSet = false;
                break;
            }
        }
        if(!allSet){
            break;
        }
    }
    if(allSet){
        [self notify:nil];
        return true;
    }
    return false;
}

// Posts a MyNotification message whenever called
- (void)notify: (WinNotificationObject*)winner {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"winner" object:winner];
}

- (void)notifySetAutoField: (SetFieldObject*)setFieldObj {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setfield" object:setFieldObj];
}

@end
