//
//  AJPlayersScrollViewController.h
//  Scoruri
//
//  Created by Anca Julean on 28/09/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AJGamesTableViewController.h"


@interface AJPlayersScrollViewController : UIViewController <AJGamesTableViewControllerDelegate>

@property (nonatomic, strong) AJGame *game;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end