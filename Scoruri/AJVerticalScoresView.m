//
//  AJVerticalScoresView.m
//  Scoruri
//
//  Created by Anca Julean on 28/09/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJVerticalScoresView.h"
#import "AJScoresManager.h"
#import "AppDelegate.h"
#import "AJScore+Additions.h"
#import "AJScoreTableViewCell.h"

@interface AJVerticalScoresView() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *scores;
@property (nonatomic, strong) AJScoresManager *scoresManager;

@end


@implementation AJVerticalScoresView

//- (id)initWithPlayer:(AJPlayer *)player {
//    self = [super init];
//    if (!self) return nil;
//
//    self = [[[NSBundle mainBundle] loadNibNamed:@"VerticalScoresView" owner:nil options:nil] lastObject];
//    self.player = player;
//    self.scores = [self.scoresManager getScoresForPlayer:self.player];
//    
//    self.scoresTable.delegate = self;
//    self.scoresTable.dataSource = self;
//    
//    [self.scoresTable registerNib:[UINib nibWithNibName:@"CenteredTextCell" bundle:nil] forCellReuseIdentifier:@"CenteredTextCellIdentifier"];
//    
//    return self;
//}

- (id)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (!self) return nil;
    
    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    
    self.scoresTable = [(UITableViewController *)[st instantiateViewControllerWithIdentifier:@"VerticalScores"] tableView];
    [self addSubview:self.scoresTable];
    
    self.scoresTable.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:self.scoresTable attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scoresTable attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.scoresTable attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.scoresTable attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    
    [self addConstraints:@[xConstraint, yConstraint, heightConstraint, widthConstraint]];
    
    self.scoresTable.delegate = self;
    self.scoresTable.dataSource = self;
    
    [self.scoresTable registerNib:[UINib nibWithNibName:@"CenteredTextCell" bundle:nil] forCellReuseIdentifier:@"CenteredTextCellIdentifier"];
    
    return self;
}

- (void)setPlayer:(AJPlayer *)player {
    if (_player != player) {
        _player = player;
        self.scores = [self.scoresManager getScoresForPlayer:_player];
    }
}

- (AJScoresManager *)scoresManager {
    if (!_scoresManager) {
        _scoresManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] scoresManager];
    }
    return _scoresManager;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 1 : [self.scores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        //cell = [tableView dequeueReusableCellWithIdentifier:@"addScoreCell"];
        AJScoreTableViewCell *addScoreCell = [tableView dequeueReusableCellWithIdentifier:@"addScoreCell"];
        
//        if (!addScoreCell) {
//            addScoreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addScoreCell"];
//        }
        addScoreCell.valueLabel.text = @"+";
        
        cell = addScoreCell;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addScoreCell"];
    } else {
        AJScoreTableViewCell *scoreCell = [tableView dequeueReusableCellWithIdentifier:@"CenteredTextCellIdentifier"];
        
//        if (!scoreCell) {
//            scoreCell = [tableView dequeueReusableCellWithIdentifier:@"CenteredTextCell"];
//        }
        
//        if (!scoreCell) {
//            //scoreCell = [[AJScoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"scoreCell"];
//            //scoreCell = [[[NSBundle mainBundle] loadNibNamed:@"ScoreCell" owner:nil options:nil] lastObject];
//        }
        
        AJScore *score = self.scores[indexPath.row];
        NSString *valueText = [NSString stringWithFormat:@"%g", [score value].doubleValue];
        scoreCell.valueLabel.text = valueText;
        
        cell = scoreCell;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CenteredTextCellIdentifier"];
    }
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return (section == 0) ? self.player.name : nil;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
//    return (section == 0) ? nil : [NSString stringWithFormat:@"%g",[self.scoresManager totalForPlayer:self.player]];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return (section == 0) ? 30.0 : 0.0;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // user clicked add score
        if ([self.delegate respondsToSelector:@selector(verticalScoresView:didClickOnAddScoreForPlayer:)]) {
            [self.delegate verticalScoresView:self didClickOnAddScoreForPlayer:self.player];
        }
    } else {
        // user clicked edit score
        if ([self.delegate respondsToSelector:@selector(verticalScoresView:didClickOnScore:)]) {
            [self.delegate verticalScoresView:self didClickOnScore:self.scores[indexPath.row]];
        }
    }
}

@end