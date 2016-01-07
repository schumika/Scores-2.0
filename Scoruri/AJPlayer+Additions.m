//
//  AJPlayer+Additions.m
//  Scoruri
//
//  Created by Anca Julean on 08/09/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//

#import "AJPlayer+Additions.h"

@implementation AJPlayer (Additions)

+ (instancetype)createNewPlayerWithPlayerId:(int)playerId andName:(NSString *)playerName forGame:(AJGame *)game inManagedObjectContext:(NSManagedObjectContext *)context {
    AJPlayer *player = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:context];
    player.playerID = @(playerId);
    player.name = playerName;
    player.game = game;
    
    return player;
}

@end
