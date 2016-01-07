//
//  AJScore+Additions.h
//  Scoruri
//
//  Created by Anca Julean on 08/09/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJScore.h"

@interface AJScore (Additions)

+ (instancetype)createScoreWithId:(int)scoreId scoreValue:(double)scoreValue forPlayer:(AJPlayer *)player inManagedObjectContext:(NSManagedObjectContext *)context;

@end
