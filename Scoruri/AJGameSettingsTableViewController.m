//
//  AJGameSettingsTableViewController.m
//  Scoruri
//
//  Created by Anca Julean on 11/01/16.
//  Copyright © 2016 Anca Julean. All rights reserved.
//

#import "AJGameSettingsTableViewController.h"
#import "AJGame+Additions.h"
#import "AJPlayer+Additions.h"
#import "AppDelegate.h"
#import "AJTextFieldTableViewCell.h"
#import "AJImageTextTableViewCell.h"
#import "AJPlayerSettingsTableViewController.h"

@interface AJGameSettingsTableViewController () <UITextFieldDelegate>

@property (nonatomic, strong) AJScoresManager *scoresManager;
@property (nonatomic, strong) NSArray *players;

@end



@implementation AJGameSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scoresManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] scoresManager];
    //self.tableView.editing = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)reloadData {
    self.title = self.game.name;
    self.players = [self.scoresManager getPlayersForGame:self.game];
    [self.tableView reloadData];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 1) ? [self.game.players count] : 1;
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
        AJImageTextTableViewCell *playerCell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
        if (!playerCell) {
            playerCell = [[AJImageTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlayerCell"];
        }
        
        playerCell.nameLabel.text = [(AJPlayer *)self.players[indexPath.row] name];
        
        cell = playerCell;
    } else if (indexPath.section == 2) {
        UITableViewCell *deleteCell = [tableView dequeueReusableCellWithIdentifier:@"DeleteCell"];
        if (!deleteCell) {
            deleteCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeleteCell"];
        }
        
        cell = deleteCell;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Game name" : (section == 1) ? @"Players" : @"";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete player
        [tableView beginUpdates];
        AJPlayer *player = (AJPlayer *)self.players[indexPath.row];
        [self.scoresManager deletePlayer:player];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        self.players = [self.scoresManager getPlayersForGame:self.game];
        [tableView endUpdates];
    }
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.game.name = textField.text;
    self.title = textField.text;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPlayerSettings"]) {
        UIViewController *ctrl = [(UINavigationController *)segue.destinationViewController topViewController];
        
        if ([ctrl respondsToSelector:@selector(setPlayer:)]) {
            int playerIndex = 0;
            
            for (int plind = 0; plind < self.players.count; plind++) {
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:plind inSection:1]];
                if ([cell isEqual:sender]) {
                    playerIndex = plind;
                    break;
                }
            }
            
            [ctrl performSelector:@selector(setPlayer:) withObject:self.players[playerIndex]];
        }
    }
}

@end
