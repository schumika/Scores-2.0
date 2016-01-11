//
//  AJGameSettingsTableViewController.m
//  Scoruri
//
//  Created by Anca Julean on 11/01/16.
//  Copyright © 2016 Anca Julean. All rights reserved.
//

#import "AJGameSettingsTableViewController.h"
#import "AJGame+Additions.h"
#import "AppDelegate.h"

@interface AJGameSettingsTableViewController ()

@property (nonatomic, strong) AJScoresManager *scoresManager;

@end



@implementation AJGameSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scoresManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] scoresManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = self.game.name;
}

- (void)dealloc {
    self.delegate = nil;
}

#pragma mark - Buttons Actions

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)deleteClicked:(id)sender {
    [self.scoresManager deleteGame:self.game];
    
    if ([self.delegate respondsToSelector:@selector(gameSettingsTVCDidDeleteGame:)]) {
        [self.delegate gameSettingsTVCDidDeleteGame:self];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableViewDatasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        UITableViewCell *deleteCell = [tableView dequeueReusableCellWithIdentifier:@"DeleteCell"];
        if (!deleteCell) {
            deleteCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeleteCell"];
        }
        
        cell = deleteCell;
    }
    
    return cell;
}

@end
