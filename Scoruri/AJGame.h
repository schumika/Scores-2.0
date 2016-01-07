//
//  AJGame.h
//  
//
//  Created by Anca Julean on 9/1/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AJPlayer;

@interface AJGame : NSManagedObject

@property (nonatomic, retain) NSNumber * gameID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *players;
@end

@interface AJGame (CoreDataGeneratedAccessors)

- (void)addPlayersObject:(AJPlayer *)value;
- (void)removePlayersObject:(AJPlayer *)value;
- (void)addPlayers:(NSSet *)values;
- (void)removePlayers:(NSSet *)values;

@end
