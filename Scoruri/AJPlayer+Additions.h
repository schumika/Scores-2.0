//
//  AJPlayer+Additions.h
//  Scoruri
//
//  Created by Anca Julean on 08/09/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJPlayer.h"

@interface AJPlayer (Additions)

+ (instancetype)createNewPlayerWithPlayerId:(int)playerId andName:(NSString *)playerName forGame:(AJGame *)game inManagedObjectContext:(NSManagedObjectContext *)context;

@end
