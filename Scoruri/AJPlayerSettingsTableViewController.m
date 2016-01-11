//
//  AJPlayerSettingsTableViewController.m
//  Scoruri
//
//  Created by Anca Julean on 11/01/16.
//  Copyright © 2016 Anca Julean. All rights reserved.
//

#import "AJPlayerSettingsTableViewController.h"
#import "AJTextFieldTableViewCell.h"
#import "AJPlayer+Additions.h"
#import "AppDelegate.h"

@interface AJPlayerSettingsTableViewController () <UITextFieldDelegate>

@end


@implementation AJPlayerSettingsTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = self.player.name;
}

#pragma mark - Buttons actions

- (IBAction)cancelCliked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)doneCliked:(id)sender {
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] scoresManager] saveContext];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableViewDataSource and Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        UITableViewCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:@"PlayerPictureCell"];
        if (!pictureCell) {
            pictureCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlayerPictureCell"];
        }
        
        cell = pictureCell;
    } else if (indexPath.section == 1) {
        AJTextFieldTableViewCell *playerNameCell = [tableView dequeueReusableCellWithIdentifier:@"PlayerNameCell"];
        if (!playerNameCell) {
            playerNameCell = [[AJTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlayerNameCell"];
        }
        playerNameCell.textField.text = self.player.name;
        [playerNameCell.textField becomeFirstResponder];
        
        cell = playerNameCell;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Player picture" : @"Player name";
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.player.name = textField.text;
    self.title = textField.text;
}

@end
