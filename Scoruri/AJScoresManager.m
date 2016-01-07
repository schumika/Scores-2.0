//
//  AJScoresManager.m
//  Scoruri
//
//  Created by Anca Julean on 9/1/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//

#import "AJScoresManager.h"

#import "AJGame+Additions.h"
#import "AJPlayer+Additions.h"
#import "AJScore+Additions.h"

@interface AJScoresManager ()

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;

@end


@implementation AJScoresManager

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.aj.Scoruri" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Scoruri" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Scoruri.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Public methods

- (NSArray *)getAllGames {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Game"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"gameID" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    NSArray *fetchedResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedResults;
}

- (void)insertNewGameWithName:(NSString *)gameName {
    [AJGame createGameWithId:[[self getAllGames] count]
                 andGameNAme:gameName
      inManagedObjectContext:self.managedObjectContext];
    
    [self saveContext];
}

- (void)deleteGame:(AJGame *)game {
    [self.managedObjectContext deleteObject:game];
    [self saveContext];
}

- (NSArray *)getAllPlayers {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Player"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"playerID" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    NSArray *fetchedResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedResults;
}

- (NSArray *)getPlayersForGame:(AJGame *)game {
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Player"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"game.gameID = %@", game.gameID];;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"playerID" ascending:YES]];
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (AJPlayer *)insertNewPlayerWithName:(NSString *)playerName forGame:(AJGame *)game {
    AJPlayer *player = [AJPlayer createNewPlayerWithPlayerId:[[self getAllPlayers] count]
                                  andName:playerName
                                  forGame:game
                   inManagedObjectContext:game.managedObjectContext];
    [self saveContext];
    return player;
}

- (NSArray *)getScoresForPlayer:(AJPlayer *)player {
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Score"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"player.playerID = %@", player.playerID];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"scoreID" ascending:YES]];
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (void)insertNewScoreWithValue:(double)val forPlayer:(AJPlayer *)player {
    [AJScore createScoreWithId:[[self getScoresForPlayer:player] count]
                    scoreValue:val
                     forPlayer:player
        inManagedObjectContext:player.managedObjectContext];
    
    [self saveContext];
}

- (double)totalForPlayer:(AJPlayer *)player {
    NSArray *scores = [self getScoresForPlayer:player];
    
    double total = 0.0;
    for (AJScore *score in scores) {
        total += score.value.doubleValue;
    }
    
    return total;
}

#pragma mark - Initial Data

- (void)populateWithDummyData {
    NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *game1 = [[NSManagedObject alloc] initWithEntity:entity1 insertIntoManagedObjectContext:self.managedObjectContext];
    [game1 setValue:@"Game1" forKey:@"name"];
    [game1 setValue:[NSNumber numberWithInt:1] forKey:@"gameID"];

    NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *game2 = [[NSManagedObject alloc] initWithEntity:entity2 insertIntoManagedObjectContext:self.managedObjectContext];
    [game2 setValue:@"Game2" forKey:@"name"];
    [game2 setValue:[NSNumber numberWithInt:2] forKey:@"gameID"];

    NSEntityDescription *entity3 = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *game3 = [[NSManagedObject alloc] initWithEntity:entity3 insertIntoManagedObjectContext:self.managedObjectContext];
    [game3 setValue:@"Game3" forKey:@"name"];
    [game3 setValue:[NSNumber numberWithInt:3] forKey:@"gameID"];

    NSEntityDescription *playerEntity1 = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *player1 = [[NSManagedObject alloc] initWithEntity:playerEntity1 insertIntoManagedObjectContext:self.managedObjectContext];
    [player1 setValue:@"Player1" forKey:@"name"];
    [player1 setValue:[NSNumber numberWithInt:1] forKey:@"playerID"];
    [player1 setValue:game1 forKey:@"game"];

    NSEntityDescription *playerEntity2 = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *player2 = [[NSManagedObject alloc] initWithEntity:playerEntity2 insertIntoManagedObjectContext:self.managedObjectContext];
    [player2 setValue:@"Player2" forKey:@"name"];
    [player2 setValue:[NSNumber numberWithInt:2] forKey:@"playerID"];
    [player2 setValue:game1 forKey:@"game"];

    NSEntityDescription *scoreEntity1 = [NSEntityDescription entityForName:@"Score" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *score1 = [[NSManagedObject alloc] initWithEntity:scoreEntity1 insertIntoManagedObjectContext:self.managedObjectContext];
    [score1 setValue:[NSNumber numberWithDouble:10.0] forKey:@"value"];
    [score1 setValue:[NSNumber numberWithInt:1] forKey:@"scoreID"];
    [score1 setValue:player1 forKey:@"player"];

    NSEntityDescription *scoreEntity2 = [NSEntityDescription entityForName:@"Score" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *score2 = [[NSManagedObject alloc] initWithEntity:scoreEntity2 insertIntoManagedObjectContext:self.managedObjectContext];
    [score2 setValue:[NSNumber numberWithDouble:20.0] forKey:@"value"];
    [score2 setValue:[NSNumber numberWithInt:2] forKey:@"scoreID"];
    [score2 setValue:player1 forKey:@"player"];

    [self saveContext];
    
    [self displayDBContents];
}

- (void)displayDBContents {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Game"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"gameID" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    NSArray *fetchedResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (AJGame *game in fetchedResults) {
        NSLog(@"game name: %@", game.name);
        
        
        NSArray *players = [game.players allObjects];
        
        for (AJPlayer *player in players) {
            NSLog(@"player name: %@", player.name);
            
            NSArray* scores = [player.scores allObjects];
            
            for (AJScore *score in scores) {
                NSLog(@"score value: %g", [score.value doubleValue]);
            }
        }
        
    }
}

@end
