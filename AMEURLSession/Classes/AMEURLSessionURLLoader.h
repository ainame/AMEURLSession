//
//  AMEURLSessionURLLoader.h
//  AMEURLSession
//
//  Created by Satoshi Namai on 2014/05/25.
//  Copyright (c) 2014年 Satoshi Namai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMEURLSessionDelegateComposer.h"
#import "AMEURLSessionTaskCreator.h"
#import "AMEURLRequestSerialization.h"
#import "AMEURLResponseSerialization.h"
#import "AMEURLSessionProtocols.h"

@interface AMEURLSessionURLLoader : NSObject

@property (nonatomic, strong) NSURLSessionConfiguration *configuration;

@property (nonatomic, strong, readonly) NSURLSession *session;

@property (nonatomic, strong) AMEURLSessionDelegateComposer *sessionDelegateComposer;

@property (nonatomic, strong) AMEURLSessionTaskCreator *sessionTaskCreator;

@property (nonatomic, strong) id<AMEURLRequestSerialization> requestSerializer;

@property (nonatomic, strong) id<AMEURLResponseSerialization> responseSerializer;

@property (nonatomic, strong) id<AMETemporaryFileManaging> temporaryFileManager;

@property (nonatomic, strong) NSOperationQueue *delegateQueue;

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration;

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration
                     sessionDelegateComposer:(AMEURLSessionDelegateComposer *)sessionDelegateComposer
                          sessionTaskCreator:(AMEURLSessionTaskCreator *)sessionTaskCreator
                           requestSerializer:(id<AMEURLRequestSerialization>)requestSerializer
                          responseSerializer:(id<AMEURLResponseSerialization>)responseSerializer
                               delegateQueue:(NSOperationQueue *)delegateQueue
                        temporaryFileManager:(id<AMETemporaryFileManaging>)temporaryFileManager;

- (NSURLSessionDataTask *)loadDataTaskWithMethod:(NSString *)method
                                             URL:(NSURL *)URL
                                      parameters:(NSDictionary *)parameters
                               completionHandler:(void (^)(NSURLSessionTask *task, id responseObject, NSError *error))completionHandler;

- (NSURLSessionUploadTask *)loadUploadTaskWithURL:(NSURL *)URL
                                       parameters:(NSDictionary *)parameters
                                             data:(NSData *)data
                                completionHandler:(void (^)(NSURLSessionTask *task, id responseObject, NSError *error))completionHandler;

- (NSURLSessionDownloadTask *)loadDownloadTaskWithURL:(NSURL *)URL
                                           parameters:(NSDictionary *)parameters
                                    completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler;

@end
