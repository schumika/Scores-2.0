//
//  AJPlayersScrollViewController.m
//  Scoruri
//
//  Created by Anca Julean on 28/09/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ADD_NEW_PLAYER_ALERT_TAG (0)
#define ADD_NEW_SCORE_ALERT_TAG (1)
#define EDIT_SCORE_ALERT_TAG (2)


#import "AJPlayersScrollViewController.h"
#import "AJScoresManager.h"
#import "AppDelegate.h"
#import "AJVerticalScoresView.h"
#import "AJScore.h"
#import "AJPlayerHeaderView.h"
#import "AJScoreTableViewCell.h"
#import "AJGame+Additions.m"
#import "AJGameSettingsTableViewController.h"


@interface AJPlayersScrollViewController() <UITableViewDataSource, UITableViewDelegate, AJGameSettingsTableViewControllerDelegate>

@property (nonatomic, strong) NSArray *players;
@property (nonatomic, strong) AJScoresManager *scoresManager;

@property (nonatomic, strong) AJPlayer *selectedPlayer;
@property (nonatomic, strong) AJScore *selectedScore;

@property (nonatomic, strong) NSArray *tables;

@property (weak, nonatomic) IBOutlet UILabel *noGamesLabel;

@end

static const double kRowIndexesTableWidth = 40.0;

@implementation AJPlayersScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scoresManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] scoresManager];
    self.scrollView.directionalLockEnabled = YES;
}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    
//    if ([self.scrollView.subviews count] > 0) {
//        for (UIView *scrollViewSubview in self.scrollView.subviews) {
//            [scrollViewSubview removeFromSuperview];
//        }
//    }
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self loadScrollViewData];
}

- (void)setGame:(AJGame *)game {
    if (game != _game) {
        _game = game;
        
        [self reloadData];
    }
}

- (void)reloadData {
    self.navigationItem.rightBarButtonItem.enabled = (self.game != nil);
    self.title = (self.game != nil) ? self.game.name : @"<No game>";
    self.noGamesLabel.hidden = (self.game != nil);
    
    if (self.game) {
        self.players = [self.scoresManager getPlayersForGame:self.game];
        [self loadScrollViewData];
    }
}

- (void)loadScrollViewData {

    [self removeTableViews];
    
    int numberOfPlayers = (int)[self.players count];
    
    CGFloat verticalViewWidth = MAX((CGRectGetWidth(self.view.bounds) - kRowIndexesTableWidth) / numberOfPlayers, 90.0) ;
    
    //CGFloat verticalWidthRatio = verticalViewWidth / self.view.bounds.size.width;
    
    CGFloat contentSizeWidth = verticalViewWidth * numberOfPlayers + kRowIndexesTableWidth;
    CGFloat contentSizeHeight = CGRectGetHeight(self.scrollView.frame);
    
     NSMutableArray *tablesArray = [NSMutableArray array];
    
    UITableView *rowIndexesTableView = [(UITableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"RowIndexes"] tableView];
    rowIndexesTableView.tag = -1;
    rowIndexesTableView.delegate = self;
    rowIndexesTableView.dataSource = self;
    
    [self.scrollView addSubview:rowIndexesTableView];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    rowIndexesTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:rowIndexesTableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:rowIndexesTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:rowIndexesTableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:rowIndexesTableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:kRowIndexesTableWidth];
    
    [self.scrollView addConstraints:@[xConstraint, yConstraint, heightConstraint, widthConstraint]];
    [rowIndexesTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    [tablesArray addObject:rowIndexesTableView];
    
    self.scrollView.contentSize = CGSizeMake(contentSizeWidth, contentSizeHeight);

    
    CGFloat xOffset = kRowIndexesTableWidth;
    for (int playerIndex=0; playerIndex<[self.players count]; playerIndex++) {
        UITableView *verticalPlayerView = [[UITableView alloc] initWithFrame:self.scrollView.bounds];
        verticalPlayerView = [(UITableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"VerticalScores"] tableView];
        verticalPlayerView.tag = playerIndex;
        
        [tablesArray addObject:verticalPlayerView];
        
        [self.scrollView addSubview:verticalPlayerView];
        
        verticalPlayerView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:verticalPlayerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:xOffset];
        NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:verticalPlayerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:verticalPlayerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:verticalPlayerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:verticalViewWidth];
        
        [self.scrollView addConstraints:@[xConstraint, yConstraint, heightConstraint, widthConstraint]];
        
        
        xOffset += verticalViewWidth;
        
        verticalPlayerView.delegate = self;
        verticalPlayerView.dataSource = self;
        
        [verticalPlayerView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    self.tables = tablesArray;
    
    [self.scrollView setNeedsUpdateConstraints];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeTableViews];
}

- (void)removeTableViews {
    
    for (UITableView *tableView in self.tables) {
        [tableView removeFromSuperview];
        
        [tableView removeObserver:self forKeyPath:@"contentOffset"];
        [tableView setDataSource:nil];
        [tableView setDelegate:nil];
    }
    
//    for (UIView *scrollViewSubview in self.scrollView.subviews) {
//        if ([scrollViewSubview isKindOfClass:[UITableView class]] && (scrollViewSubview.tag == -1)) {
//            [scrollViewSubview removeObserver:self forKeyPath:@"contentOffset"];
//            [(UITableView *)scrollViewSubview setDataSource:nil];
//            [(UITableView *)scrollViewSubview setDelegate:nil];
//        }
//        [scrollViewSubview removeFromSuperview];
//    }
    
    self.tables = nil;
}

- (void)dealloc {
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    static BOOL isObservingContentOffsetChange = NO;
    if([object isKindOfClass:[UITableView class]] && [keyPath isEqualToString:@"contentOffset"]) {
        if(isObservingContentOffsetChange) return;
        
        isObservingContentOffsetChange = YES;
        for (UIView *scrollViewSubview in self.scrollView.subviews) {
            if ([scrollViewSubview isKindOfClass:[UITableView class]]) {
                //if (scrollViewSubview.tag != -1) {
                    if(scrollViewSubview != object) {
                        CGPoint offset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
                        ((UITableView *)scrollViewSubview).contentOffset = offset;
                    }
                //}
            }
        }
        isObservingContentOffsetChange = NO;
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


#pragma mark - Button actions

- (IBAction)addPlayerButtonClicked:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add new player" message:@"Insert new player name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.tag = ADD_NEW_PLAYER_ALERT_TAG;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}


#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[alertView textFieldAtIndex:0] resignFirstResponder];
    
    if (alertView.tag == ADD_NEW_PLAYER_ALERT_TAG) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            AJPlayer *player = [self.scoresManager insertNewPlayerWithName:[[alertView textFieldAtIndex:0] text] forGame:self.game];
            self.selectedPlayer = player;
            
            AJPlayer *anotherPlayer = nil;
            for (AJPlayer *player in self.players) {
                if (player != self.selectedPlayer) {
                    anotherPlayer = player;break;
                }
            }
            if (anotherPlayer) {
                for (int i=0; i<[anotherPlayer.scores count]; i++) {
                    [self.scoresManager insertNewScoreWithValue:0.0 forPlayer:self.selectedPlayer];
                }
            }
            
            [self reloadData];
        }
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (tableView.tag == -1) ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == -1) {
        return (section == 0 ? [self.scoresManager maximumNumberOfScoresForGame:self.game] : 1);
    }
    return [[self.players[tableView.tag] scores] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (tableView.tag == -1) {
        if (indexPath.section == 0) {
            AJScoreTableViewCell *rowCell = [tableView dequeueReusableCellWithIdentifier:@"RowCell"];
            if (!rowCell) {
                rowCell = [[AJScoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RowCell"];
            }
            rowCell.valueLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
            
            cell = rowCell;
        } else {
            AJScoreTableViewCell *addRoundCell = [tableView dequeueReusableCellWithIdentifier:@"AddRoundCell"];
            if (!addRoundCell) {
                addRoundCell = [[AJScoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddRoundCell"];
            }
            
            cell = addRoundCell;
        }
    } else {
        AJScoreTableViewCell *scoreCell = [tableView dequeueReusableCellWithIdentifier:@"scoreCell"];
        if (!scoreCell) {
            scoreCell = [[AJScoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"scoreCell"];
        }
        AJScore *score = [self.scoresManager getScoresForPlayer:self.players[tableView.tag]][indexPath.row];
        scoreCell.valueLabel.text = [NSString stringWithFormat:@"%g", score.value.doubleValue];
        
        cell = scoreCell;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag != -1) {
        AJPlayer *player = self.players[tableView.tag];

        UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:@"PlayerHeader"];
        UILabel *nameLabel = [headerView viewWithTag:1000]; // name label
        nameLabel.text = player.name;
        UILabel *totalLabel = [headerView viewWithTag:1001]; // total label
        totalLabel.text = [NSString stringWithFormat:@"%g", [self.scoresManager totalForPlayer:player]];
        
        return headerView;
    } else {
        UIView *header = [[tableView dequeueReusableCellWithIdentifier:@"RoundsHeader"] contentView];
        header.backgroundColor = [UIColor whiteColor];
        return (section == 0) ? header : nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 62.0 : 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == -1) {
        if (indexPath.section == 0) {
            [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([view isKindOfClass:[UITableView class]]) {
                    [(UITableView *)view selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
            }];
        } else if (indexPath.section == 1) {
            for (AJPlayer *player in self.players) {
                [self.scoresManager insertNewScoreWithValue:0.0 forPlayer:player];
            }
            
            [self reloadData];
        }
    } else {
        
        self.selectedPlayer = self.players[tableView.tag];
        
        // user clicked on existing score to edit
        
        self.selectedScore = [self.scoresManager getScoresForPlayer:self.players[tableView.tag]][indexPath.row];;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Edit score for %@", self.selectedScore.player.name]
                                                            message:@"New score:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alertView.tag = EDIT_SCORE_ALERT_TAG;
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [alertView show];
    }
}

#pragma mark - AJGamesTableViewControllerDelegate methods

- (void)gamesTVC:(AJGamesTableViewController *)tvc didSelectGame:(AJGame *)game {
    self.game = game;
}

#pragma mark - AJGameSettingsTableViewControllerDelegate methods

-(void)gameSettingsTVCDidDeleteGame:(AJGameSettingsTableViewController *)gameSettingsTVC {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowGameSettings"]) {
        UIViewController *ctrl = [(UINavigationController *)segue.destinationViewController topViewController];
        if ([ctrl respondsToSelector:@selector(setGame:)]) {
            [ctrl performSelector:@selector(setGame:) withObject:self.game];
            [(AJGameSettingsTableViewController *)ctrl setDelegate:self];
        }
    }
}

@end
