//
//  AJGameSettingsTableViewController.h
//  Scoruri
//
//  Created by Anca Julean on 11/01/16.
//  Copyright © 2016 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AJGame;

@protocol AJGameSettingsTableViewControllerDelegate;


@interface AJGameSettingsTableViewController : UITableViewController

@property (nonatomic, strong) AJGame *game;
@property (nonatomic, weak) id<AJGameSettingsTableViewControllerDelegate> delegate;

@end


@protocol AJGameSettingsTableViewControllerDelegate <NSObject>

- (void)gameSettingsTVCDidDeleteGame:(AJGameSettingsTableViewController *)gameSettingsTVC;

@end
