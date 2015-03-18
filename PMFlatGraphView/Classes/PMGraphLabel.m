//
//  PMGraphLabel.m
//  PMFlatGraphView
//
//  Created by Taku Inoue on 2014/02/20.
//  Copyright (c) 2014年 Peromasamune. All rights reserved.
//

#import "PMGraphLabel.h"

@implementation PMGraphLabel

static float LabelFontSize = 17.f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setMinimumScaleFactor:1.f/LabelFontSize];
        [self setFont:[UIFont boldSystemFontOfSize:LabelFontSize]];
        [self setTextColor: [UIColor darkGrayColor]];
        
        self.numberOfLines = 0;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        self.adjustsFontSizeToFitWidth = YES;
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
