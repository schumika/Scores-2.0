//
//  AJGameCollectionViewController.m
//  Scoruri
//
//  Created by Anca Julean on 27/10/15.
//  Copyright © 2015 Anca Julean. All rights reserved.
//

#import "AJGameCollectionViewController.h"
#import "AJPlayerCollectionViewCell.h"
#import "AppDelegate.h"
#import "AJScoresManager.h"
#import "AJPlayer+Additions.h"


#define ADD_NEW_PLAYER_ALERT_TAG            100
#define ADD_NEW_SCORE_ALERT_TAG             101

@interface AJGameCollectionViewController () <UIAlertViewDelegate, AJPlayerCollectionViewCellDelegate>

@property (nonatomic, strong) AJScoresManager *scoresManager;
@property (nonatomic, strong) NSIndexPath *selectedPlayerIndex;

@end

@implementation AJGameCollectionViewController

static NSString * const reuseIdentifier = @"PlayerCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionViewLayout.minimumInteritemSpacing = 0.0;
    self.collectionView.collectionViewLayout = collectionViewLayout;
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPlayerButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:barBtnItem];
    
    self.scoresManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] scoresManager];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UICollectionViewFlowLayout *flowLayout = (id)self.collectionView.collectionViewLayout;
    
    if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)) {
        flowLayout.itemSize = CGSizeMake(170.0, self.collectionView.frame.size.height /*- CGRectGetHeight(self.navigationController.navigationBar.frame)*/);
    } else {
        flowLayout.itemSize = CGSizeMake(120.0, self.collectionView.frame.size.height /*- CGRectGetHeight(self.navigationController.navigationBar.frame) - 20.0*/);
    }
    
    //[flowLayout invalidateLayout]; //force the elements to get laid out again with the new size
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.game.players count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AJPlayerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    AJPlayer *player = [self.scoresManager getPlayersForGame:self.game][indexPath.row];
    
    cell.player = player;
    [cell reloadUI];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)sectio {
    return UIEdgeInsetsZero;
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (IBAction)addPlayerButtonClicked:(UIBarButtonItem *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add new player" message:@"Insert new player name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.tag = ADD_NEW_PLAYER_ALERT_TAG;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}


#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == ADD_NEW_PLAYER_ALERT_TAG) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            // user clicked "OK"
            if ([[alertView textFieldAtIndex:0] text]) {
                [self.scoresManager insertNewPlayerWithName:[[alertView textFieldAtIndex:0] text] forGame:self.game];
                
                [self.collectionView reloadData];
            }
            
        }
    } else if (alertView.tag == ADD_NEW_SCORE_ALERT_TAG) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            
            if ([[alertView textFieldAtIndex:0] text]) {
                [self.scoresManager insertNewScoreWithValue:[[alertView textFieldAtIndex:0] text].doubleValue forPlayer:[self.scoresManager getPlayersForGame:self.game][self.selectedPlayerIndex.row]];
                
                [self.collectionView reloadItemsAtIndexPaths:@[self.selectedPlayerIndex]];
            }
            
        }
    }
    
}

#pragma mark - AJPlayerCollectionViewCellDelegate methods

- (void)playerCollectionViewCellDidClickAddScore:(AJPlayerCollectionViewCell *)cell {
    
    [[self.scoresManager getPlayersForGame:self.game] enumerateObjectsUsingBlock:^(AJPlayer *player, NSUInteger idx, BOOL * _Nonnull stop) {
        if (player == cell.player) {
            self.selectedPlayerIndex = [NSIndexPath indexPathForRow:idx inSection:0];
            *stop = NO;
        }
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add new score" message:@"Insert new score value:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.tag = ADD_NEW_SCORE_ALERT_TAG;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

@end
