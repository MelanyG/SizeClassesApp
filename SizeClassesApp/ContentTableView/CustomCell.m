//
//  CustomCell.m
//  SizeClassesApp
//
//  Created by Melany Gulianovych on 6/17/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize imageView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
