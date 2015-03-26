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

#pragma mark -- PMFlatGraphView --

@protocol PMFlatGraphViewDataSource;

@class PMFlatGraphContentsView;
@interface PMFlatGraphView : UIView

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) PMFlatGraphContentsView *graphView;
@property (nonatomic) UIView *yAxisView;
@property (nonatomic, weak) id<PMFlatGraphViewDataSource> dataSource;

-(void)reloadGraph;

@end

#pragma mark -- PMFlatGraphViewDelegate --

@protocol PMFlatGraphViewDataSource <NSObject>
-(NSInteger)PMFlatGraphViewNumberOfGraphInView;
-(PMGraphDataItem *)PMFlatGraphView:(PMFlatGraphView *)graphView viewForItemInGraphIndex:(NSInteger)index;
@optional
-(NSArray *)PMFlatGraphViewYAxisCustomBorder; //Array of PMGraphDataiItem
@end

#pragma mark -- PMFlatGraphContentsView --

@interface PMFlatGraphContentsView : UIView

@property (nonatomic) NSArray *graphDataArray;
@property (nonatomic) NSArray *xLabels, *yLabels;
@property (nonatomic) NSArray *customYAxisBorder;
@property (nonatomic) NSMutableArray * pathPoints;

@property (nonatomic,assign) CGFloat xLabelWidth, yLabelHeight;         //Label width
@property (nonatomic,assign) double yMinimunStepValue;                  //y Axis minimun steps value
@property (nonatomic,assign) double xStepValue;
@property (nonatomic,assign) NSInteger xStepInterval;
@property (nonatomic,assign) CGFloat graphCavanHeight, graphCavanWidth;
@property (nonatomic,assign) CGFloat graphMargin;
@property (nonatomic,assign) CGFloat startPointMargin;
@property (nonatomic,assign) BOOL showLabel;
@property (nonatomic,assign) BOOL drawYaxisBorder;
@property (nonatomic,assign) BOOL drawXaxisBorder;
@property (nonatomic,assign) BOOL isValueReverse;
@property (nonatomic,assign) BOOL isCombineXLabel;

-(void)drawGraph;
-(UIView *)getYAxisLabelView;

@end
