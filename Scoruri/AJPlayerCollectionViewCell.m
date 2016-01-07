//
//  AJPlayerCollectionViewCell.m
//  Scoruri
//
//  Created by Anca Julean on 08/12/15.
//  Copyright © 2015 Anca Julean. All rights reserved.
//

#import "AJPlayerCollectionViewCell.h"
#import "AJScoreTableViewCell.h"
#import "AJPlayerHeaderView.h"
#import "AJScore+Additions.h"
#import "AJPlayer+Additions.h"
#import "AppDelegate.h"

@interface AJPlayerCollectionViewCell() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation AJPlayerCollectionViewCell


- (void)awakeFromNib {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)reloadUI {
    self.playerName = self.player.name;
    self.scores = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] scoresManager] getScoresForPlayer:self.player];
    
    ((AJPlayerHeaderView *)self.tableView.tableHeaderView).playerLabel.text = self.playerName;
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate and DataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 1 : self.scores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        AJScoreTableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:@"AddCell" forIndexPath:indexPath];
        addCell.valueLabel.text = @"+";
        
        cell = addCell;
    } else {
        AJScoreTableViewCell *scoreCell = [tableView dequeueReusableCellWithIdentifier:@"ScoreCell" forIndexPath:indexPath];
        
        AJScore *score = self.scores[indexPath.row];
        scoreCell.valueLabel.text = [NSString stringWithFormat:@"%g", score.value.doubleValue];
        
        cell = scoreCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // add score
        
        if ([self.delegate respondsToSelector:@selector(playerCollectionViewCellDidClickAddScore:)]) {
            [self.delegate playerCollectionViewCellDidClickAddScore:self];
        }
    }
}


@end
