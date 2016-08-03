//
//  SocketManager.m
//  CocoaSocketDemo
//
//  Created by lasso on 16/8/3.
//  Copyright © 2016年 lasso. All rights reserved.
//

#import "SocketManager.h"
#import "GCDAsyncSocket.h"

@interface SocketManager () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) NSTimer *connectTimer;
@property (nonatomic, assign) BOOL stop;

@end

@implementation SocketManager


+ (instancetype)sharedManager
{
    static dispatch_once_t token;
    static SocketManager *sharedInstance = nil;
    dispatch_once(&token, ^{
         sharedInstance = [self new];
    });
    return sharedInstance;
}

- (void)startSocket
{
    [self socketConnect];
    self.stop = NO;
}

- (void)stopSocket
{
    [self.socket disconnect];
    self.stop = YES;
}


- (void)socketConnect
{
    if (!self.socket) {
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("lasso.queue", NULL)];
    }
    
    NSError *error = nil;
    [self.socket connectToHost:@"127.0.0.1" onPort:52000 withTimeout:3 error:&error];
}

#pragma mark  - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
        [self.connectTimer fire];
    });
    
    [sock readDataWithTimeout:-1 tag:1];
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err
{
    NSLog(@"sorry the connect is failure %@", err);
    if (!self.stop) {
          [self socketConnect]; // 重新连接
    }
  
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 从服务器得到的数据
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    [sock readDataWithTimeout:-1 tag:tag];
}

#pragma mark - timer handler
-(void)longConnectToSocket{
    
    static long long token = 0;
    token ++;
    NSString *longConnect = [NSString stringWithFormat:@"can you hear me? %lld", token];
    
    NSData   *dataStream  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.socket writeData:dataStream withTimeout:3 tag:100];
    
}


@end
