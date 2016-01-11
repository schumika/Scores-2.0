//
//  AJImageTextTableViewCell.m
//  Scoruri
//
//  Created by Anca Julean on 11/01/16.
//  Copyright © 2016 Anca Julean. All rights reserved.
//

#import "AJImageTextTableViewCell.h"

@implementation AJImageTextTableViewCell

- (void)awakeFromNib {
    self.separatorHeightConstraint.constant = 0.5;
}

@end
