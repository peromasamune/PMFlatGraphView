//
//  PMGraphDataItem.h
//  PMFlatGraphView
//
//  Created by Taku Inoue on 2014/02/19.
//  Copyright (c) 2014年 Peromasamune. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PMGraphLineStyleDefault = 0,
    PMGraphLineStyleDashed  = 1,
}PMGraphLineStyle;

@interface PMGraphDataItem : NSObject

@property (nonatomic) NSArray *dataArray; //グラフのデータを格納
@property (nonatomic) UIColor *lineColor; //線の色
@property (nonatomic) PMGraphLineStyle lineStyle; //線のスタイル
@property (nonatomic) CGFloat atPoint; //線の位置 (for Custom border)

-(NSInteger)getGraphItemCount;
-(CGFloat)getGraphDataY:(NSInteger)index;

@end
