//
//  SocketManager.h
//  CocoaSocketDemo
//
//  Created by lasso on 16/8/3.
//  Copyright © 2016年 lasso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketManager : NSObject

+ (instancetype)sharedManager;
- (void)startSocketWithHost:(NSString *)host port:(NSInteger)port;
- (void)stopSocket;

@end
