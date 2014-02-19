//
//  PMGraphDataItem.m
//  PMFlatGraphView
//
//  Created by Taku Inoue on 2014/02/19.
//  Copyright (c) 2014年 Peromasamune. All rights reserved.
//

#import "PMGraphDataItem.h"

@implementation PMGraphDataItem

-(NSInteger)getGraphItemCount{
    return [self.dataArray count];
}

-(CGFloat)getGraphDataY:(NSInteger)index{
    if (index > [self.dataArray count]) {
        return 0;
    }
    return [[self.dataArray objectAtIndex:index] floatValue];
}

@end
