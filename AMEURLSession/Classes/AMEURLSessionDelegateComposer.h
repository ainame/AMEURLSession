//
//  AMEURLSessionDelegateComposer.h
//  AMEURLSession
//
//  Created by Satoshi Namai on 2014/05/25.
//  Copyright (c) 2014年 Satoshi Namai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMEURLSessionDelegateComposer
    : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate, NSCopying>

@property (nonatomic, weak) id<NSURLSessionDelegate> delegate;

@property (nonatomic, weak) id<NSURLSessionTaskDelegate> taskDelegate;

@property (nonatomic, weak) id<NSURLSessionDataDelegate> dataDelegate;

@property (nonatomic, weak) id<NSURLSessionDownloadDelegate> downloadDelegate;

@property (nonatomic, copy) void (^backgroundCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);

- (instancetype)initWithDelegate:(id<NSURLSessionDelegate>)delegate
                    taskDelegate:(id<NSURLSessionTaskDelegate>)taskDelegate
                    dataDelegate:(id<NSURLSessionDataDelegate>)dataDelegate
                downloadDelegate:(id<NSURLSessionDownloadDelegate>)downloadDelegate
     backgroundCompletionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))backgroundCompletionHandler;

- (instancetype)initWithBackgroundCompletionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))backgroundCompletionHandler;

@end
