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
#import "AJTextFieldTableViewCell.h"

@interface AJGameSettingsTableViewController () <UITextFieldDelegate>

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

- (IBAction)doneClicked:(id)sender {
    self.game.name = [[(AJTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textField] text];
    
    [self.scoresManager saveContext];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        AJTextFieldTableViewCell *gameNameCell = [tableView dequeueReusableCellWithIdentifier:@"GameNameCell"];
        if (!gameNameCell) {
            gameNameCell = [[AJTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GameNameCell"];
        }
        gameNameCell.textField.text = self.game.name;
        gameNameCell.textField.delegate = self;
        
        cell = gameNameCell;
    } else if (indexPath.section == 1) {
        UITableViewCell *deleteCell = [tableView dequeueReusableCellWithIdentifier:@"DeleteCell"];
        if (!deleteCell) {
            deleteCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeleteCell"];
        }
        
        cell = deleteCell;
    }
    
    return cell;
}


#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.game.name = textField.text;
    self.title = textField.text;
}

@end
