//
//  ViewController.m
//  WTLoading
//
//  Created by Yorke on 16/1/30.
//  Copyright © 2016年 WuTong. All rights reserved.
//

#import "ViewController.h"
#import "LeafLoading.h"

@interface ViewController ()

@property (nonatomic, strong) LeafLoading *leafLoading;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *leafView = [[UIView alloc]initWithFrame:CGRectMake(10, 100, 300, 230)];
    leafView.backgroundColor = [UIColor colorWithRed:0.99 green:0.80 blue:0.34 alpha:1.0f];
    [self.view addSubview:leafView];
    
    UILabel *loading = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 300, 30)];
    loading.text = @"loading...";
    loading.textColor = [UIColor colorWithRed:0.91 green:0.64 blue:0.21 alpha:1.0f];
    loading.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:18];
    loading.textAlignment = NSTextAlignmentCenter;
    [leafView addSubview:loading];
    
    _leafLoading = [[LeafLoading alloc]init];
    _leafLoading.center = CGPointMake(150, 120);
    [leafView addSubview:_leafLoading];
    
    UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
    [start setTitle:@"启动" forState:UIControlStateNormal];
    [start setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [start setFrame:CGRectMake(0, 0, 100, 100)];
    [start addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)startAction:(id)sender{
    _leafLoading.progress = 0.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
