//
//  AJScoresTableViewController.m
//  Scoruri
//
//  Created by Anca Julean on 9/4/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//

#import "AJScoresTableViewController.h"
#import "AppDelegate.h"
#import "AJPlayer.h"
#import "AJScore.h"

@interface AJScoresTableViewController ()

@property (nonatomic, strong) NSArray *scores;
@property (nonatomic, strong) AJScoresManager *scoresManager;

@end


@implementation AJScoresTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scoresManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] scoresManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData {
    self.scores = [self.scoresManager getScoresForPlayer:self.player];
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.scores count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ScoreCell"];
    }
    
    AJScore *score = self.scores[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%g", score.value.doubleValue];
    
    return cell;
}


#pragma mark - Operations

- (IBAction)addScoreButtonClicked:(UIBarButtonItem *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add new score" message:@"Insert new score:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeDecimalPad;
    [alertView show];
}


#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        // user clicked "OK"
        if ([[alertView textFieldAtIndex:0] text]) {
            [self.scoresManager insertNewScoreWithValue:[[alertView textFieldAtIndex:0] text].doubleValue forPlayer:self.player];
            
            [self reloadData];
        }
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
