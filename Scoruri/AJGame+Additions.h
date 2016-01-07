//
//  AJGame+Additions.h
//  Scoruri
//
//  Created by Anca Julean on 07/09/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AJGame.h"

@interface AJGame (Additions)

+ (instancetype)createGameWithId:(int)gameId andGameNAme:(NSString *)gameName inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
