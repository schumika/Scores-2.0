//
//  AJScore+Additions.m
//  Scoruri
//
//  Created by Anca Julean on 08/09/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//

#import "AJScore+Additions.h"

@implementation AJScore (Additions)

+ (instancetype)createScoreWithId:(int)scoreId scoreValue:(double)scoreValue forPlayer:(AJPlayer *)player inManagedObjectContext:(NSManagedObjectContext *)context {
    AJScore *score = [NSEntityDescription insertNewObjectForEntityForName:@"Score" inManagedObjectContext:context];
    score.scoreID = @(scoreId);
    score.value = @(scoreValue);
    score.player = player;
    
    return score;
}

@end
