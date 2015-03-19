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
        self.scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        self.graphView = [[PMFlatGraphContentsView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.scrollView addSubview:self.graphView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self reloadGraph];
}

-(void)reloadGraph{
    if (!self.graphView || !self.dataSource) {
        return;
    }
    
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
    
    CGFloat contentsMargin = labelView.frame.size.width;
    
    UIView *yAxisLabelBorderView = [[UIView alloc] initWithFrame:CGRectMake(contentsMargin, 0, 1, self.frame.size.height - self.graphView.yLabelHeight * 2 + self.graphView.yLabelHeight/2)];
    yAxisLabelBorderView.backgroundColor = [UIColor lightGrayColor];
    [self.yAxisView addSubview:yAxisLabelBorderView];
    
    self.yAxisView.frame = CGRectMake(0, 0, contentsMargin, labelView.frame.size.height);
    [self.yAxisView addSubview: labelView];
    
    CGRect scrollFrame = self.scrollView.frame;
    scrollFrame.origin.x = contentsMargin;
    scrollFrame.size.width -= contentsMargin;
    self.scrollView.frame = scrollFrame;
}

#pragma mark Property Method

-(void)setDataSource:(id<PMFlatGraphViewDataSource>)dataSource{
    if (dataSource) {
        _dataSource = dataSource;
    }
}

@end

#pragma mark -- PMFlatGraphContentsView --

@interface PMFlatGraphContentsView()

@property (nonatomic) NSMutableArray *graphLineArray;
@property (nonatomic) NSMutableArray *graphPath;

@property (nonatomic,assign) NSInteger yLabelNum;
@property (nonatomic,assign) double yValueMax, yValueMin;
@property (nonatomic,assign) NSInteger xLabelMaxCount;

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
        self.userInteractionEnabled = YES;

        _showLabel = YES;
        _isValueReverse = NO;
        _isCombineXLabel = NO;
        _graphLineArray = [NSMutableArray new];
        _pathPoints = [[NSMutableArray alloc] init];
        _yMinimunStepValue = 0.1;
        _xStepValue = 1.0;
        _xStepInterval = 1.0;
        _yLabelHeight = [PMGraphLabel getFontSize];
        _graphMargin = 40;
        _startPointMargin = 5;
        _drawYaxisBorder = YES;
        _drawXaxisBorder = NO;
        _graphCavanWidth = self.frame.size.width;
        _graphCavanHeight = self.frame.size.height - _yLabelHeight * 2;
    }
    return self;
}

#pragma mark Class Method

-(void)prepareDrawGraph{
    if(!_showLabel){
        _graphCavanHeight = self.frame.size.height - 2*_yLabelHeight;
        _graphCavanWidth = self.frame.size.width - _startPointMargin*2;
        _graphMargin = 0.0;
    }else{
        _graphCavanWidth = self.frame.size.width - _startPointMargin*2 - _graphMargin;
    }
}

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
        
        NSMutableArray * linePointsArray = [[NSMutableArray alloc] init];
        [progressline setLineWidth:3.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];

        if (_isCombineXLabel) {
            _xLabelWidth = (_graphCavanWidth / ([graphItem.dataArray count] -1));
        }else{
            _xLabelWidth = (_graphCavanWidth / (_xLabelMaxCount -1));
        }
        
        for (NSUInteger i = 0; i < [graphItem getGraphItemCount]; i++) {
            
            yValue = [graphItem getGraphDataY:i] * ((_isValueReverse) ? (-1) : 1);
            
            innerGrade = (yValue - _yValueMin) / ( _yValueMax - _yValueMin);
            
            point = CGPointMake((i * _xLabelWidth) + _startPointMargin, _graphCavanHeight - (innerGrade * _graphCavanHeight) + ( _yLabelHeight /2 ));
            
            if (i != 0) {
                [progressline addLineToPoint:point];
            }

            //UIBezierPath *roundIconPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-5, point.y-5, 10, 10) cornerRadius:5];
            //[progressline appendPath:roundIconPath];

            if (i==0 || i==[graphItem getGraphItemCount]-1) {
                UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
                iconView.backgroundColor = [UIColor whiteColor];
                iconView.layer.cornerRadius = 6;
                iconView.layer.borderColor = graphItem.lineColor.CGColor;
                iconView.layer.borderWidth = 3;
                iconView.center = point;
                [self addSubview:iconView];
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

        graphLine.path = progressline.CGPath;
        
//        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        pathAnimation.duration = 1.0;
//        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
//        [graphLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];

        graphLine.strokeEnd = 1.0;

        UIGraphicsEndImageContext();
    }
}

-(UIView *)getYAxisLabelView{

    if (!_showLabel) {
        return nil;
    }
    
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _graphMargin, self.frame.size.height)];
    labelView.backgroundColor = [UIColor clearColor];

	CGFloat yStepHeight = _graphCavanHeight / _yLabelNum;
    
    NSInteger index = 0;
    NSInteger num = _yLabelNum+1;

	while (num > 0) {
		PMGraphLabel * label = [[PMGraphLabel alloc] initWithFrame:CGRectMake(0.0, (_graphCavanHeight - index * yStepHeight), _graphMargin, _yLabelHeight)];
		[label setTextAlignment:NSTextAlignmentRight];
        if (_yMinimunStepValue < 1.0) {
            label.text = [NSString stringWithFormat:@"%.1f",_yValueMin + (_yMinimunStepValue * index)];
        }else{
            label.text = [NSString stringWithFormat:@"%1f",_yValueMin + (_yMinimunStepValue * index)];
        }
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
    
    int stepNum = (_yValueMax - _yValueMin) / _yMinimunStepValue;
    
    if (fmod(_yValueMax,_yMinimunStepValue) > 0.f) {
        stepNum++;
        int maxStep = _yValueMax / _yMinimunStepValue;
        _yValueMax = (maxStep * _yMinimunStepValue) + _yMinimunStepValue;
    }
    if (fmod(_yValueMin, _yMinimunStepValue) < 0.f) {
        stepNum++;
        int minStep = _yValueMin / _yMinimunStepValue;
        _yValueMin = (minStep * _yMinimunStepValue) - _yMinimunStepValue;
    }
    
    _yLabelNum = stepNum;
}

#pragma mark Property Method

-(void)setYLabels:(NSArray *)yLabels{

    if(_drawYaxisBorder){
        CGFloat yStepHeight = _graphCavanHeight / _yLabelNum;
        NSInteger index = 0;
        NSInteger num = _yLabelNum+1;
        CGFloat currentVal = _yValueMin;
        while (num > 0) {
            CGFloat borderWidth = (currentVal == 0) ? 3 : 1;

            UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, (_graphCavanHeight - index * yStepHeight) + _yLabelHeight/2, self.frame.size.width, borderWidth)];
            borderView.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:borderView];
            [self sendSubviewToBack:borderView];

            index +=1 ;
            num -= 1;
            currentVal += _yMinimunStepValue;
        }
    }else{
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, _graphCavanHeight + _yLabelHeight/2, self.frame.size.width, 1)];
        borderView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:borderView];
    }
}

-(void)setXLabelsWithLabelCount:(NSInteger)count{

    if (_isCombineXLabel) {
        return;
    }

    NSInteger labelCount = count / _xStepValue;
    NSInteger labelIndex = 0;

    if (_showLabel) {
        CGFloat labelWidth = (_graphCavanWidth/labelCount)*_xStepInterval;

        for (int i = 0; i < labelCount; i++) {
            if (i == 0 || i % _xStepInterval == 0) {
                PMGraphLabel *label = [[PMGraphLabel alloc] initWithFrame:CGRectInset(CGRectMake((labelIndex * labelWidth) + _startPointMargin, _yLabelHeight + _graphCavanHeight, labelWidth, _yLabelHeight), 1, 0)];
                label.text = [NSString stringWithFormat:@"%ld",(long)i];
                [self addSubview:label];

                if (_drawXaxisBorder && i != 0) {
                    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake((labelIndex * labelWidth) + _startPointMargin + 5, 0, 1, _graphCavanHeight + _yLabelHeight/2)];
                    borderView.backgroundColor = [UIColor lightGrayColor];
                    [self addSubview:borderView];
                    [self sendSubviewToBack:borderView];
                }

                labelIndex++;
            }
        }
    }

}

-(void)setGraphDataArray:(NSArray *)graphDataArray{
    
    if (graphDataArray == _graphDataArray) {
        return;
    }
    
    NSMutableArray *yLabelsArray = [NSMutableArray array];
    CGFloat yMax = 0.0f;
    CGFloat yMin = 0.0f;
    CGFloat yValue;
    NSInteger labelCount = 0;
    
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
            yValue = [graphItem getGraphDataY:i] * ((_isValueReverse) ? (-1) : 1);
            [yLabelsArray addObject:[NSString stringWithFormat:@"%f", yValue]];
            yMax = fmaxf(yMax, yValue);
            yMin = fminf(yMin, yValue);
        }

        labelCount = MAX(labelCount, [graphItem.dataArray count]);
    }
    
    _yValueMax = yMax;
    _yValueMin = yMin;
    _xLabelMaxCount = labelCount;

    [self prepareDrawGraph];
    [self checkYLabelsStepValue];
    
    _graphDataArray = graphDataArray;
    
    [self setYLabels:yLabelsArray];
    [self setXLabelsWithLabelCount:labelCount];
    
    [self setNeedsDisplay];
}

@end
