//
//  PMGraphLabel.m
//  PMFlatGraphView
//
//  Created by Taku Inoue on 2014/02/20.
//  Copyright (c) 2014年 Peromasamune. All rights reserved.
//

#import "PMGraphLabel.h"

@implementation PMGraphLabel

static float LabelFontSize = 11.f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setLineBreakMode:NSLineBreakByWordWrapping];
        [self setMinimumScaleFactor:8.0f];
        [self setNumberOfLines:0];
        [self setFont:[UIFont boldSystemFontOfSize:LabelFontSize]];
        [self setTextColor: [UIColor darkGrayColor]];
        self.backgroundColor = [UIColor clearColor];
        [self setTextAlignment:NSTextAlignmentLeft];
        self.userInteractionEnabled = YES;
    }
    return self;
}

+(CGFloat)getFontSize{
    return LabelFontSize;
}

+(void)setFontSize:(CGFloat)size{
    LabelFontSize = size;
}

@end
