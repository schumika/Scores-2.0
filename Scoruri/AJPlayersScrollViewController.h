//
//  AJPlayersScrollViewController.h
//  Scoruri
//
//  Created by Anca Julean on 28/09/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AJGame.h"

@interface AJPlayersScrollViewController : UIViewController

@property (nonatomic, strong) AJGame *game;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end