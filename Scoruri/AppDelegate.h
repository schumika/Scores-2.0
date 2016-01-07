//
//  AppDelegate.h
//  Scoruri
//
//  Created by Anca Julean on 9/1/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJScoresManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AJScoresManager *scoresManager;

@end

