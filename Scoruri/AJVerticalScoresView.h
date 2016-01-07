//
//  AJVerticalScoresView.h
//  Scoruri
//
//  Created by Anca Julean on 28/09/15.
//  Copyright (c) 2015 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJPlayer+Additions.h"

@class AJVerticalScoresView;

@protocol AJVerticalScoresViewDelegate <NSObject>

- (void)verticalScoresView:(AJVerticalScoresView *)scoresView didClickOnAddScoreForPlayer:(AJPlayer *)player;
- (void)verticalScoresView:(AJVerticalScoresView *)scoresView didClickOnScore:(AJScore *)score;

@end

@interface AJVerticalScoresView : UIView

@property (nonatomic, strong) AJPlayer *player;
@property (nonatomic, readonly) IBOutlet UITableView *scoresTable;
@property (nonatomic, weak) id<AJVerticalScoresViewDelegate> delegate;

- (id)initWithPlayer:(AJPlayer *)player;
- (void)setXOffset:(CGFloat)xOffset andWidth:(CGFloat)width;

@end