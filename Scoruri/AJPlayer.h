//
//  AJPlayer.h
//  
//
//  Created by Anca Julean on 9/1/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AJGame, AJScore;

@interface AJPlayer : NSManagedObject

@property (nonatomic, retain) NSNumber * playerID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) AJGame *game;
@property (nonatomic, retain) NSSet *scores;
@end

@interface AJPlayer (CoreDataGeneratedAccessors)

- (void)addScoresObject:(AJScore *)value;
- (void)removeScoresObject:(AJScore *)value;
- (void)addScores:(NSSet *)values;
- (void)removeScores:(NSSet *)values;

@end
