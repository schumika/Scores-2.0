//
//  AJGamesTableViewController.h
//  Scoruri
//
//  Created by Anca Julean on 9/2/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AJGame;

@protocol AJGamesTableViewControllerDelegate;


@interface AJGamesTableViewController : UITableViewController

@property (nonatomic, weak) id<AJGamesTableViewControllerDelegate> gamesDelegate;

@end


@protocol AJGamesTableViewControllerDelegate <NSObject>

- (void)gamesTVC:(AJGamesTableViewController *)tvc didSelectGame:(AJGame *)game;

@end
