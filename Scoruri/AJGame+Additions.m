//
//  AJGame+Additions.m
//  Scoruri
//
//  Created by Anca Julean on 07/09/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//

#import "AJGame+Additions.h"

@implementation AJGame (Additions)

+ (instancetype)createGameWithId:(int)gameId andGameNAme:(NSString *)gameName inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    AJGame *game = [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:managedObjectContext];
    game.gameID = @(gameId);
    game.name = gameName;
    
    return game;
}

@end
