//
//  ViewController.m
//  PMFlatGraphView
//
//  Created by Taku Inoue on 2014/02/19.
//  Copyright (c) 2014年 Peromasamune. All rights reserved.
//

#import "ViewController.h"
#import "PMFlatGraphView.h"

@interface ViewController () <PMFlatGraphViewDataSource>
@property (nonatomic) NSMutableArray *graphDataArray;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [PMGraphLabel setFontSize:14];
    
    self.graphDataArray = [NSMutableArray array];
    
    PMGraphDataItem *item = [PMGraphDataItem new];
    item.dataArray = @[@60.1, @160.1, @126.4, @262.2, @186.2, @20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
    item.lineColor = [UIColor redColor];
    
    [self.graphDataArray addObject:item];
    
    PMFlatGraphView *graphView = [[PMFlatGraphView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    graphView.dataSource = self;
    graphView.center = self.view.center;
    graphView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:graphView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- PMFlatGraphViewDataSource --

-(NSInteger)PMFlatGraphViewNumberOfGraphInView{
    return 1;
}

-(PMGraphDataItem *)PMFlatGraphView:(PMFlatGraphView *)graphView viewForItemInGraphIndex:(NSInteger)index{
    return (PMGraphDataItem *)[self.graphDataArray objectAtIndex:index];
}

-(NSArray *)PMFlatGraphViewTitleArrayForXAxis{
    return @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
}

@end
