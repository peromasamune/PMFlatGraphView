//
//  PMFlatGraphView.h
//  PMFlatGraphView
//
//  Created by Taku Inoue on 2014/02/19.
//  Copyright (c) 2014年 Peromasamune. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMGraphDataItem.h"
#import "PMGraphLabel.h"

@interface PMFlatGraphView : UIView

@property (nonatomic) NSArray *graphDataArray;
@property (nonatomic) NSArray *xLabels, *yLabels;
@property (nonatomic) NSMutableArray * pathPoints;

@property (nonatomic,assign) CGFloat xLabelWidth, yLabelHeight;         //Label width
@property (nonatomic,assign) double yMinimunStepValue;                  //y Axis minimun steps value
@property (nonatomic,assign) CGFloat graphCavanHeight, graphCavanWidth;
@property (nonatomic,assign) CGFloat graphMargin;
@property (nonatomic,assign) BOOL showLabel;

-(void)drawGraph;

@end
