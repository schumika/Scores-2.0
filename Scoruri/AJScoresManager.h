//
//  AJScoresManager.h
//  Scoruri
//
//  Created by Anca Julean on 9/1/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AJGame;
@class AJPlayer;


@interface AJScoresManager : NSObject

- (void)saveContext;

// Public methods
- (NSArray *)getAllGames;
- (void)insertNewGameWithName:(NSString *)gameName;
- (void)deleteGame:(AJGame *)game;
- (NSArray *)getPlayersForGame:(AJGame *)game;
- (NSArray *)getScoresForPlayer:(AJPlayer *)player;
- (double)totalForPlayer:(AJPlayer *)player;
- (AJPlayer *)insertNewPlayerWithName:(NSString *)playerName forGame:(AJGame *)game;
- (void)insertNewScoreWithValue:(double)val forPlayer:(AJPlayer *)player;
- (int)maximumNumberOfScoresForGame:(AJGame *)game;

// For Testing purposes
- (void)populateWithDummyData;
- (void)displayDBContents;

@end
