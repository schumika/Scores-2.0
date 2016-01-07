//
//  AJScore.h
//  
//
//  Created by Anca Julean on 9/1/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AJPlayer;

@interface AJScore : NSManagedObject

@property (nonatomic, retain) NSNumber * scoreID;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) AJPlayer *player;

@end
