//
//  ViewController.m
//  PMFlatGraphView
//
//  Created by Taku Inoue on 2014/02/19.
//  Copyright (c) 2014年 Peromasamune. All rights reserved.
//

#import "ViewController.h"
#import "PMFlatGraphView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    PMFlatGraphView *graphView = [[PMFlatGraphView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
    graphView.center = self.view.center;
    graphView.backgroundColor = [UIColor whiteColor];
    
    [graphView setXLabels:@[@"1",@"2",@"3",@"4",@"5"]];
    
    PMGraphDataItem *item = [PMGraphDataItem new];
    item.dataArray = @[@60.1, @160.1, @126.4, @262.2, @186.2];
    item.lineColor = [UIColor redColor];
    
    graphView.graphDataArray = @[item];
    [self.view addSubview:graphView];
    
    [graphView drawGraph];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
