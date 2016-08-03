//
//  ViewController.m
//  CocoaSocketDemo
//
//  Created by lasso on 16/8/3.
//  Copyright © 2016年 lasso. All rights reserved.
//

#import "ViewController.h"
#import "SocketManager.h"

@interface ViewController ()

@property (nonatomic, strong) SocketManager *sharedManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)startSocket:(id)sender
{
    self.sharedManager = [SocketManager sharedManager];
    [self.sharedManager startSocket];
}


- (IBAction)stopSocket:(id)sender
{
    [self.sharedManager stopSocket];
}



@end
