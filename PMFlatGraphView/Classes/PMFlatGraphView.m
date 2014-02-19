//
//  PMFlatGraphView.m
//  PMFlatGraphView
//
//  Created by Taku Inoue on 2014/02/19.
//  Copyright (c) 2014年 Peromasamune. All rights reserved.
//

#import "PMFlatGraphView.h"

@interface PMFlatGraphView()

@property (nonatomic) NSMutableArray *graphLineArray;
@property (nonatomic) NSMutableArray *graphPath;

@end

@implementation PMFlatGraphView

#pragma mark -- Initialize --

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds   = YES;
        self.graphLineArray  = [NSMutableArray new];
        _showLabel           = YES;
        _pathPoints = [[NSMutableArray alloc] init];
        self.userInteractionEnabled = YES;
        
        _yLabelNum = 5.0;
        _yLabelHeight = [[[[UILabel alloc] init] font] pointSize];
        
        _chartMargin = 30;
        
        _chartCavanWidth = self.frame.size.width - _chartMargin *2;
        _chartCavanHeight = self.frame.size.height - _chartMargin * 2;
    }
    return self;
}

#pragma mark -- Class Method --

-(void)drawGraph{
    
    _graphPath = [[NSMutableArray alloc] init];
    //Draw each line
    for (NSUInteger lineIndex = 0; lineIndex < self.graphDataArray.count; lineIndex++) {
        PMGraphDataItem *graphItem = self.graphDataArray[lineIndex];
        CAShapeLayer *chartLine = (CAShapeLayer *) self.graphLineArray[lineIndex];
        CGFloat yValue;
        CGFloat innerGrade;
        CGPoint point;
        
        UIGraphicsBeginImageContext(self.frame.size);
        UIBezierPath * progressline = [UIBezierPath bezierPath];
        [_graphPath addObject:progressline];
        
        
        
        if(!_showLabel){
            _chartCavanHeight = self.frame.size.height - 2*_yLabelHeight;
            _chartCavanWidth = self.frame.size.width;
            _chartMargin = 0.0;
            _xLabelWidth = (_chartCavanWidth / ([_xLabels count] -1));
        }
        
        NSMutableArray * linePointsArray = [[NSMutableArray alloc] init];
        [progressline setLineWidth:3.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        
        for (NSUInteger i = 0; i < [graphItem getGraphItemCount]; i++) {
            
            yValue = [graphItem getGraphDataY:i];
            
            innerGrade = (yValue - _yValueMin) / ( _yValueMax - _yValueMin);
            
            point = CGPointMake(2*_chartMargin +  (i * _xLabelWidth), _chartCavanHeight - (innerGrade * _chartCavanHeight) + ( _yLabelHeight /2 ));
            
            if (i != 0) {
                [progressline addLineToPoint:point];
            }
            
            [progressline moveToPoint:point];
            [linePointsArray addObject:[NSValue valueWithCGPoint:point]];
        }
        [_pathPoints addObject:[linePointsArray copy]];
        
        if (graphItem.lineColor) {
            chartLine.strokeColor = graphItem.lineColor.CGColor;
        }else{
            chartLine.strokeColor = [UIColor greenColor].CGColor;
        }
        
        [progressline stroke];
        
        chartLine.path = progressline.CGPath;
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1.0;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        chartLine.strokeEnd = 1.0;
        
        UIGraphicsEndImageContext();
    }
}

#pragma mark -- Private Method --

#pragma mark -- Property Method --

-(void)setYLabels:(NSArray *)yLabels{
    
    CGFloat yStep = (_yValueMax-_yValueMin) / _yLabelNum;
	CGFloat yStepHeight = _chartCavanHeight / _yLabelNum;
    
    
    NSInteger index = 0;
	NSInteger num = _yLabelNum+1;
	while (num > 0) {
		UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (_chartCavanHeight - index * yStepHeight), _chartMargin, _yLabelHeight)];
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
        _xLabelWidth = _chartCavanWidth/[xLabels count];
        
        for(int index = 0; index < xLabels.count; index++)
        {
            labelText = xLabels[index];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(2*_chartMargin +  (index * _xLabelWidth) - (_xLabelWidth / 2), _chartMargin + _chartCavanHeight, _xLabelWidth, _chartMargin)];
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
        //グラフデータが同一の場合return
        return;
    }
    
    NSMutableArray *yLabelsArray = [NSMutableArray array];
    CGFloat yMax = 0.0f;
    CGFloat yMin = MAXFLOAT;
    CGFloat yValue;
    
    for (CALayer *layer in self.graphLineArray) {
        [layer removeFromSuperlayer];
    }
    self.graphLineArray = [NSMutableArray array];
    
    for (PMGraphDataItem *graphItem in graphDataArray) {
        
        CAShapeLayer *chartLine = [CAShapeLayer layer];
        chartLine.lineCap   = kCALineCapRound;
        chartLine.lineJoin  = kCALineJoinBevel;
        chartLine.fillColor = [[UIColor whiteColor] CGColor];
        chartLine.lineWidth = 3.0;
        chartLine.strokeEnd = 0.0;
        [self.layer addSublayer:chartLine];
        [self.graphLineArray addObject:chartLine];
        
        for (NSUInteger i = 0; i < [graphItem getGraphItemCount]; i++) {
            yValue = [graphItem getGraphDataY:i];
            [yLabelsArray addObject:[NSString stringWithFormat:@"%2f", yValue]];
            yMax = fmaxf(yMax, yValue);
            yMin = fminf(yMin, yValue);
        }
    }
    
    if (yMax < 5) {
        yMax = 5.0f;
    }
    if (yMin < 0){
        yMin = 0.0f;
    }
    
    _yValueMin = yMin;
    _yValueMax = yMax;
    
    _graphDataArray = graphDataArray;
    
    if (_showLabel) {
        [self setYLabels:yLabelsArray];
    }
    
    [self setNeedsDisplay];
}

@end
