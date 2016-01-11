//
//  AJGameSettingsTableViewController.m
//  Scoruri
//
//  Created by Anca Julean on 11/01/16.
//  Copyright © 2016 Anca Julean. All rights reserved.
//

#import "AJGameSettingsTableViewController.h"
#import "AJGame+Additions.h"

@implementation AJGameSettingsTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = self.game.name;
}

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

@end
