//
//  PMGraphDataItem.h
//  PMFlatGraphView
//
//  Created by Taku Inoue on 2014/02/19.
//  Copyright (c) 2014年 Peromasamune. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMGraphDataItem : NSObject

@property (nonatomic) NSArray *dataArray; //グラフのデータを格納
@property (nonatomic) UIColor *lineColor; //線の色

-(NSInteger)getGraphItemCount;
-(CGFloat)getGraphDataY:(NSInteger)index;

@end
