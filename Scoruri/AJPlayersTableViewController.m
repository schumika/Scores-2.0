//
//  AJPlayersTableViewController.m
//  Scoruri
//
//  Created by Anca Julean on 9/4/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//

#import "AJPlayersTableViewController.h"
#import "AppDelegate.h"
#import "AJPlayer.h"
#import "AJScoresTableViewController.h"

@interface AJPlayersTableViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *players;
@property (nonatomic, strong) AJScoresManager *scoresManager;

@end

@implementation AJPlayersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scoresManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] scoresManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)reloadData {
    self.players = [self.scoresManager getPlayersForGame:self.game];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.players count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlayerCell"];
    }
    
    AJPlayer *player = (AJPlayer *)self.players[indexPath.row];
    cell.textLabel.text = player.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%g", [[(AppDelegate *)[[UIApplication sharedApplication] delegate] scoresManager] totalForPlayer:player]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowScores"]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setPlayer:)]) {
            AJPlayer *player = self.players[[self.tableView indexPathForSelectedRow].row];
            [segue.destinationViewController setPlayer:player];
        }
    }
}

#pragma mark - Operations

- (IBAction)addPlayerButtonClicked:(UIBarButtonItem *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add new player" message:@"Insert new player name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}


#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        // user clicked "OK"
        if ([[alertView textFieldAtIndex:0] text]) {
            [self.scoresManager insertNewPlayerWithName:[[alertView textFieldAtIndex:0] text] forGame:self.game];
            
            [self reloadData];
        }
        
    }
}

@end
