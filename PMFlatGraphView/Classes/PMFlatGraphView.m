//
//  PMFlatGraphView.m
//  PMFlatGraphView
//
//  Created by Taku Inoue on 2014/02/19.
//  Copyright (c) 2014年 Peromasamune. All rights reserved.
//

#import "PMFlatGraphView.h"

@interface PMFlatGraphView()
@end

@implementation PMFlatGraphView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.contentSize = CGSizeMake(frame.size.width * 2, frame.size.height);
        [self addSubview:self.scrollView];
        
        self.graphView = [[PMFlatGraphContentsView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width * 2, frame.size.height)];
        self.graphView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:self.graphView];
    }
    return self;
}

-(void)reloadGraph{
    if (!self.graphView || !self.dataSource) {
        return;
    }
    
    [self.graphView setXLabels:[self.dataSource PMFlatGraphViewTitleArrayForXAxis]];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i=0; i < [self.dataSource PMFlatGraphViewNumberOfGraphInView]; i++) {
        [array addObject:[self.dataSource PMFlatGraphView:self viewForItemInGraphIndex:i]];
    }
    
    self.graphView.graphDataArray = array;
    [self.graphView drawGraph];
    
    if (self.yAxisView) {
        for (UIView *view in self.yAxisView.subviews){
            [view removeFromSuperview];
        }
    }else{
        self.yAxisView = [UIView new];
        [self addSubview:self.yAxisView];
    }
    UIView *labelView = [self.graphView getYAxisLabelView];
    labelView.backgroundColor = [UIColor whiteColor];
    [self.yAxisView addSubview: labelView];
}

#pragma mark Property Method

-(void)setDataSource:(id<PMFlatGraphViewDataSource>)dataSource{
    if (dataSource) {
        _dataSource = dataSource;
        [self reloadGraph];
    }
}

@end

#pragma mark -- PMFlatGraphContentsView --

@interface PMFlatGraphContentsView()

@property (nonatomic) NSMutableArray *graphLineArray;
@property (nonatomic) NSMutableArray *graphPath;

@property (nonatomic,assign) NSInteger yLabelNum;
@property (nonatomic,assign) double yValueMax, yValueMin;

@end

@implementation PMFlatGraphContentsView

#pragma mark Initialize

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.graphLineArray = [NSMutableArray new];
        self.userInteractionEnabled = YES;
        
        _showLabel = YES;
        _pathPoints = [[NSMutableArray alloc] init];
        _yMinimunStepValue = 100;
        _yValueMin = 0;
        _yLabelHeight = [PMGraphLabel getFontSize];
        _graphMargin = 40;
        _graphCavanWidth = self.frame.size.width - _graphMargin;
        _graphCavanHeight = self.frame.size.height - _yLabelHeight * 2;
    }
    return self;
}

#pragma mark Class Method

-(void)drawGraph{
    
    _graphPath = [[NSMutableArray alloc] init];
    
    for (NSUInteger lineIndex = 0; lineIndex < self.graphDataArray.count; lineIndex++) {
        PMGraphDataItem *graphItem = self.graphDataArray[lineIndex];
        CAShapeLayer *graphLine = (CAShapeLayer *) self.graphLineArray[lineIndex];
        CGFloat yValue;
        CGFloat innerGrade;
        CGPoint point;
        
        UIGraphicsBeginImageContext(self.frame.size);
        UIBezierPath * progressline = [UIBezierPath bezierPath];
        [_graphPath addObject:progressline];
        
        if(!_showLabel){
            _graphCavanHeight = self.frame.size.height - 2*_yLabelHeight;
            _graphCavanWidth = self.frame.size.width;
            _graphMargin = 0.0;
            _xLabelWidth = (_graphCavanWidth / ([_xLabels count] -1));
        }
        
        NSMutableArray * linePointsArray = [[NSMutableArray alloc] init];
        [progressline setLineWidth:3.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        
        for (NSUInteger i = 0; i < [graphItem getGraphItemCount]; i++) {
            
            yValue = [graphItem getGraphDataY:i];
            
            innerGrade = (yValue - _yValueMin) / ( _yValueMax - _yValueMin);
            
            point = CGPointMake(_graphMargin + (i * _xLabelWidth) + _xLabelWidth/2, _graphCavanHeight - (innerGrade * _graphCavanHeight) + ( _yLabelHeight /2 ));
            
            if (i != 0) {
                [progressline addLineToPoint:point];
            }
            
            [progressline moveToPoint:point];
            [linePointsArray addObject:[NSValue valueWithCGPoint:point]];
        }
        [_pathPoints addObject:[linePointsArray copy]];
        
        if (graphItem.lineColor) {
            graphLine.strokeColor = graphItem.lineColor.CGColor;
        }else{
            graphLine.strokeColor = [UIColor greenColor].CGColor;
        }
        
        [progressline stroke];
        
        graphLine.path = progressline.CGPath;
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1.0;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [graphLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        graphLine.strokeEnd = 1.0;
        
        UIGraphicsEndImageContext();
    }
}

-(UIView *)getYAxisLabelView{
    
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _graphMargin, self.frame.size.height)];
    labelView.backgroundColor = [UIColor clearColor];
    
    CGFloat yStep = (_yValueMax-_yValueMin) / _yLabelNum;
	CGFloat yStepHeight = _graphCavanHeight / _yLabelNum;
    
    NSInteger index = 0;
	NSInteger num = _yLabelNum+1;
	while (num > 0) {
		PMGraphLabel * label = [[PMGraphLabel alloc] initWithFrame:CGRectMake(0.0, (_graphCavanHeight - index * yStepHeight), _graphMargin, _yLabelHeight)];
		[label setTextAlignment:NSTextAlignmentRight];
		label.text = [NSString stringWithFormat:@"%1.f",_yValueMin + (yStep * index)];
		[labelView addSubview:label];
        index +=1 ;
		num -= 1;
	}
    
    return labelView;
}

#pragma mark Private Method

-(void)checkYLabelsStepValue{
    
    if (_yValueMax == 0) {
        return;
    }
    
    int stepNum = _yValueMax / _yMinimunStepValue;
    
    if (fmod(_yValueMax,_yMinimunStepValue) > 0.f) {
        stepNum++;
        _yValueMax = _yMinimunStepValue*stepNum;
    }
    
    _yLabelNum = stepNum;
}

#pragma mark Property Method

-(void)setYLabels:(NSArray *)yLabels{
    
    CGFloat yStep = (_yValueMax-_yValueMin) / _yLabelNum;
	CGFloat yStepHeight = _graphCavanHeight / _yLabelNum;
    
    NSInteger index = 0;
	NSInteger num = _yLabelNum+1;
	while (num > 0) {
		PMGraphLabel * label = [[PMGraphLabel alloc] initWithFrame:CGRectMake(0.0, (_graphCavanHeight - index * yStepHeight), _graphMargin, _yLabelHeight)];
		[label setTextAlignment:NSTextAlignmentRight];
		label.text = [NSString stringWithFormat:@"%1.f",_yValueMin + (yStep * index)];
		[self addSubview:label];
        index +=1 ;
		num -= 1;
	}
}

-(void)setXLabels:(NSArray *)xLabels{
    
    _xLabels = xLabels;
    NSString* labelText;
    if(_showLabel){
        _xLabelWidth = _graphCavanWidth/[xLabels count];
        
        for(int index = 0; index < xLabels.count; index++)
        {
            labelText = xLabels[index];
            PMGraphLabel * label = [[PMGraphLabel alloc] initWithFrame:CGRectMake(_graphMargin +  (index * _xLabelWidth), _yLabelHeight+_graphCavanHeight, _xLabelWidth, _yLabelHeight)];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.text = labelText;
            [self addSubview:label];
        }
        
    }else{
        _xLabelWidth = (self.frame.size.width)/[xLabels count];
    }
}

-(void)setGraphDataArray:(NSArray *)graphDataArray{
    
    if (graphDataArray == _graphDataArray) {
        return;
    }
    
    NSMutableArray *yLabelsArray = [NSMutableArray array];
    CGFloat yMax = 0.0f;
    CGFloat yValue;
    
    for (CALayer *layer in self.graphLineArray) {
        [layer removeFromSuperlayer];
    }
    self.graphLineArray = [NSMutableArray array];
    
    for (PMGraphDataItem *graphItem in graphDataArray) {
        
        CAShapeLayer *graphLine = [CAShapeLayer layer];
        graphLine.lineCap   = kCALineCapRound;
        graphLine.lineJoin  = kCALineJoinBevel;
        graphLine.fillColor = [[UIColor whiteColor] CGColor];
        graphLine.lineWidth = 3.0;
        graphLine.strokeEnd = 0.0;
        [self.layer addSublayer:graphLine];
        [self.graphLineArray addObject:graphLine];
        
        for (NSUInteger i = 0; i < [graphItem getGraphItemCount]; i++) {
            yValue = [graphItem getGraphDataY:i];
            [yLabelsArray addObject:[NSString stringWithFormat:@"%2f", yValue]];
            yMax = fmaxf(yMax, yValue);
        }
    }
    
    _yValueMax = yMax;
    [self checkYLabelsStepValue];
    
    _graphDataArray = graphDataArray;
    
    if (_showLabel) {
        //[self setYLabels:yLabelsArray];
    }
    
    [self setNeedsDisplay];
}

@end
