//
//  PMFlatGraphView.h
//  PMFlatGraphView
//
//  Created by Taku Inoue on 2014/02/19.
//  Copyright (c) 2014年 Peromasamune. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMGraphDataItem.h"

@interface PMFlatGraphView : UIView

@property (nonatomic) NSArray *graphDataArray;
@property (nonatomic) NSArray *xLabels, *yLabels;
@property (nonatomic) NSMutableArray * pathPoints;

@property (nonatomic,assign) NSInteger yLabelNum;
@property (nonatomic,assign) CGFloat xLabelWidth, yLabelHeight;
@property (nonatomic,assign) CGFloat yValueMax, yValueMin;
@property (nonatomic,assign) CGFloat chartCavanHeight, chartCavanWidth;
@property (nonatomic,assign) CGFloat chartMargin;
@property (nonatomic,assign) BOOL showLabel;

-(void)drawGraph;

@end
