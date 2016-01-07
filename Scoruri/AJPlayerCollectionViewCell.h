//
//  AJPlayerCollectionViewCell.h
//  Scoruri
//
//  Created by Anca Julean on 08/12/15.
//  Copyright © 2015 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AJPlayer;

@protocol AJPlayerCollectionViewCellDelegate;


@interface AJPlayerCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) AJPlayer *player;

@property (nonatomic, strong) NSString *playerName;
@property (nonatomic, strong) NSArray *scores;

@property (nonatomic, weak) id<AJPlayerCollectionViewCellDelegate> delegate;

- (void)reloadUI;

@end


@protocol AJPlayerCollectionViewCellDelegate <NSObject>

- (void)playerCollectionViewCellDidClickAddScore:(AJPlayerCollectionViewCell *)cell;

@end