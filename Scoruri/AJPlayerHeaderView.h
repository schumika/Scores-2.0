//
//  PlayerHeaderView.h
//  Scoruri
//
//  Created by Anca Julean on 10/12/15.
//  Copyright © 2015 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJPlayerHeaderView : UIView

@property (nonatomic, weak) IBOutlet UILabel *playerLabel;

@property (nonatomic, weak) IBOutlet UILabel *playerNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *playerImage;
@property (nonatomic, weak) IBOutlet UILabel *playerTotalLabel;

@end
