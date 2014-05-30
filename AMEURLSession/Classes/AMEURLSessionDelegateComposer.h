//
//  AMEURLSessionDelegateComposer.h
//  AMEURLSession
//
//  Created by Satoshi Namai on 2014/05/25.
//  Copyright (c) 2014年 Satoshi Namai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMEURLSessionDelegateComposer : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, weak) id<NSURLSessionDelegate> delegate;

@property (nonatomic, weak) id<NSURLSessionTaskDelegate> taskDelegate;

@property (nonatomic, weak) id<NSURLSessionDataDelegate> dataDelegate;

@property (nonatomic, weak) id<NSURLSessionDownloadDelegate> downloadDelegate;

@property (nonatomic, copy) void (^backgroundCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);

- (instancetype)initWithBackgroundCompletionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))backgroundCompletionHandler;

@end
