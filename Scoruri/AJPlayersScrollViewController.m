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

@interface AJPlayersScrollViewController() <AJVerticalScoresViewDelegate>

@property (nonatomic, strong) NSArray *players;
@property (nonatomic, strong) AJScoresManager *scoresManager;

@property (nonatomic, strong) AJPlayer *selectedPlayer;
@property (nonatomic, strong) AJScore *selectedScore;

@end

@implementation AJPlayersScrollViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scoresManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] scoresManager];
    self.scrollView.directionalLockEnabled = YES;
    
    self.title = self.game.name;
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

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    [self loadScrollViewData];
//}

- (void)reloadData {
    self.players = [self.scoresManager getPlayersForGame:self.game];
    [self loadScrollViewData];
}

- (void)loadScrollViewData {
//    if ([self.scrollView.subviews count] > 0) {
//        for (UIView *scrollViewSubview in self.scrollView.subviews) {
//            [scrollViewSubview removeFromSuperview];
//        }
//    }
    
    int numberOfPlayers = (int)[self.players count];
    
    CGFloat verticalViewWidth = CGRectGetWidth(self.view.bounds) / numberOfPlayers;
    
    CGFloat minimumWidth = 70.0;
    
    if (verticalViewWidth < minimumWidth) {
        verticalViewWidth = (CGRectGetWidth(self.view.bounds) - 30.0) / 4.0;
    }
    
    CGFloat verticalWidthRatio = verticalViewWidth / self.view.bounds.size.width;
    
    CGFloat contentSizeWidth = verticalViewWidth * numberOfPlayers;
    CGFloat contentSizeHeight = CGRectGetHeight(self.view.bounds); // TODO: adjust!
    
    CGFloat topBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    self.scrollView.contentSize = CGSizeMake(contentSizeWidth, contentSizeHeight);
    CGFloat xOffset = 0.0;
    for (AJPlayer *player in self.players) {
        AJVerticalScoresView *verticalScoresView = [[AJVerticalScoresView alloc] initWithPlayer:player];
        verticalScoresView.frame = self.scrollView.bounds;
        verticalScoresView.delegate = self;
        //[verticalScoresView setXOffset:xOffset andWidth:verticalViewWidth];
        [self.scrollView addSubview:verticalScoresView];
        
        verticalScoresView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:verticalScoresView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:xOffset];
        NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:verticalScoresView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topBarHeight];
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:verticalScoresView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:verticalScoresView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:verticalWidthRatio constant:0.0];
        
        [self.scrollView addConstraints:@[xConstraint, yConstraint, heightConstraint, widthConstraint]];
        
        xOffset += verticalViewWidth;
        
    }
    
    self.scrollView.backgroundColor = [UIColor yellowColor];
    
    //UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
//    AJVerticalScoresView *blueView = [[AJVerticalScoresView alloc] initWithPlayer:nil];
//    blueView.backgroundColor = [UIColor blueColor];
//    [self.scrollView addSubview:blueView];
//    self.scrollView.contentSize = self.scrollView.bounds.size;
//    
//    blueView.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:blueView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:xOffset];
//    NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:blueView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:0.0];
//    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:blueView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
//    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:blueView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0.0];
//    
//    [self.scrollView addConstraints:@[xConstraint, yConstraint, heightConstraint, widthConstraint]];
//    
//    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:blueView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:100.0];
//
//        [blueView addConstraint:widthConstraint];
    
}


#pragma - AJVerticalScoresViewDelegate methods

- (void)verticalScoresView:(AJVerticalScoresView *)scoresView didClickOnAddScoreForPlayer:(AJPlayer *)player {
    self.selectedPlayer = player;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Add new score for %@", player.name]
                                                        message:@"Insert new score:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.tag = ADD_NEW_SCORE_ALERT_TAG;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeDecimalPad;
    [alertView show];
}

- (void)verticalScoresView:(AJVerticalScoresView *)scoresView didClickOnScore:(AJScore *)score {
    self.selectedScore = score;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Edit score for %@", score.player.name]
                                                        message:@"New score:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.tag = EDIT_SCORE_ALERT_TAG;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeDecimalPad;
    [alertView show];
}

#pragma mark - Button actions

- (IBAction)addPlayerButtonClicked:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add new player" message:@"Insert new player name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.tag = ADD_NEW_PLAYER_ALERT_TAG;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

#pragma mark - Operations

- (IBAction)addScoreButtonClicked:(UIBarButtonItem *)sender {
    
}


#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
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
    } else if (alertView.tag == ADD_NEW_SCORE_ALERT_TAG) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            if ([[alertView textFieldAtIndex:0] text]) {
                for (AJPlayer *player in self.players) {
                    if (player == self.selectedPlayer) {
                        [self.scoresManager insertNewScoreWithValue:[[alertView textFieldAtIndex:0] text].doubleValue forPlayer:self.selectedPlayer];
                    } else {
                        [self.scoresManager insertNewScoreWithValue:0.0 forPlayer:player];
                    }
                }
                
                [self reloadData];
            }
            
        }
        self.selectedPlayer = nil;
    } else if (alertView.tag == EDIT_SCORE_ALERT_TAG) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            self.selectedScore.value = @([[alertView textFieldAtIndex:0] text].doubleValue);
            [self.scoresManager saveContext];
            
            [self reloadData];
        }
        self.selectedScore = nil;
    }
}


@end
