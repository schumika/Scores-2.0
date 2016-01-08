//
//  AJGamesTableViewController.m
//  Scoruri
//
//  Created by Anca Julean on 9/2/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//

#import "AJGamesTableViewController.h"
#import "AJGame.h"
#import "AppDelegate.h"
#import "AJPlayersTableViewController.h"
#import "AJPlayersScrollViewController.h"
#import "AJGameCollectionViewController.h"

@interface AJGamesTableViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *games;
@property (nonatomic, strong) AJScoresManager *scoresManager;

@end

@implementation AJGamesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.scoresManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] scoresManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)reloadData {
    self.games = [self.scoresManager getAllGames];
    [self.tableView reloadData];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GameCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    AJGame *game = self.games[indexPath.row];
    cell.textLabel.text = game.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.splitViewController showDetailViewController:(AJPlayersScrollViewController *)self.gamesDelegate sender:nil];
    
    __weak typeof(self) weakself = self;
    if ([self.gamesDelegate respondsToSelector:@selector(gamesTVC:didSelectGame:)]) {
        [self.gamesDelegate gamesTVC:weakself didSelectGame:self.games[indexPath.row]];
    }
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
//
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    if ([segue.identifier  isEqualToString: @"showPlayers"]) {
//        if ([segue.destinationViewController respondsToSelector:@selector(setGame:)]) {
//            [(AJPlayersTableViewController *)segue.destinationViewController setGame:self.games[[self.tableView indexPathForSelectedRow].row]];
//        }
//    } else if ([segue.identifier isEqualToString:@"showPlayersVertical"]) {
//        if ([segue.destinationViewController respondsToSelector:@selector(setGame:)]) {
//            [(AJPlayersScrollViewController *)segue.destinationViewController setGame:self.games[[self.tableView indexPathForSelectedRow].row]];
//        }
//    } else if ([segue.identifier isEqualToString:@"showGameCollection"]) {
//        if ([segue.destinationViewController respondsToSelector:@selector(setGame:)]) {
//            [(AJGameCollectionViewController *)segue.destinationViewController setGame:self.games[[self.tableView indexPathForSelectedRow].row]];
//        }
//    }
//}

#pragma mark - Operations
- (IBAction)addButtonClicked:(UIBarButtonItem *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add new game" message:@"Insert new game name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        // user clicked "OK"
        if ([[alertView textFieldAtIndex:0] text]) {
            [self.scoresManager insertNewGameWithName:[[alertView textFieldAtIndex:0] text]];
            
            [self reloadData];
        }
        
    }
}


@end
