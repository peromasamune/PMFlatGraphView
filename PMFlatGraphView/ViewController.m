//
//  ViewController.m
//  PMFlatGraphView
//
//  Created by Taku Inoue on 2014/02/19.
//  Copyright (c) 2014年 Peromasamune. All rights reserved.
//  test

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
    
    [PMGraphLabel setFontSize:14];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    scrollView.center = self.view.center;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, 200);
    [self.view addSubview:scrollView];
    
    PMFlatGraphView *graphView = [[PMFlatGraphView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 2, 200)];
    graphView.backgroundColor = [UIColor whiteColor];
    
    [graphView setXLabels:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"]];
    
    PMGraphDataItem *item = [PMGraphDataItem new];
    item.dataArray = @[@60.1, @160.1, @126.4, @262.2, @186.2, @20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
    item.lineColor = [UIColor redColor];
    
    graphView.graphDataArray = @[item];
    [scrollView addSubview:graphView];
    
    [graphView drawGraph];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
