//
//  AMEURLSessionURLLoader.m
//  AMEURLSession
//
//  Created by Satoshi Namai on 2014/05/25.
//  Copyright (c) 2014年 Satoshi Namai. All rights reserved.
//

#import "AMEURLSessionURLLoader.h"
#import "AMEURLRequestSerialization.h"
#import "AMEURLSessionDelegateComposer.h"
#import "AMEURLSessionTaskCreator.h"
#import "AMESimpleTemporaryFileManager.h"

@implementation AMEURLSessionURLLoader

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    return [self initWithSessionConfiguration:configuration
                      sessionDelegateComposer:[AMEURLSessionDelegateComposer new]
                           sessionTaskCreator:[AMEURLSessionTaskCreator new]
                            requestSerializer:[AMEURLRequestHTTPRequestSerializer new]   // default serializers
                           responseSerializer:[AMEURLResponseJSONSResponSerializer new]  //
                                delegateQueue:[[NSOperationQueue alloc] init]
                         temporaryFileManager:[AMESimpleTemporaryFileManager new]];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration
                     sessionDelegateComposer:(AMEURLSessionDelegateComposer *)sessionDelegateComposer
                          sessionTaskCreator:(AMEURLSessionTaskCreator *)sessionTaskCreator
                           requestSerializer:(id<AMEURLRequestSerialization>)requestSerializer
                          responseSerializer:(id<AMEURLResponseSerialization>)responseSerializer
                               delegateQueue:(NSOperationQueue *)delegateQueue
                        temporaryFileManager:(id<AMETemporaryFileManaging>)temporaryFileManager
{
    self = [self init];
    if (self) {
        _configuration = configuration;
        _sessionDelegateComposer = sessionDelegateComposer;
        _sessionTaskCreator = sessionTaskCreator;
        _sessionTaskCreator.requestSerializer = requestSerializer;
        _responseSerializer = responseSerializer;
        _delegateQueue = delegateQueue;
        _temporaryFileManager = temporaryFileManager;
    }
    return self;
}

- (NSURLSessionDataTask *)loadDataTaskWithMethod:(NSString *)method
                                             URL:(NSURL *)URL
                                      parameters:(NSDictionary *)parameters
                               completionHandler:(void (^)(NSURLSessionTask *task, id responseObject, NSError *error))completionHandler
{
    __block NSURLSessionDataTask *task =
        [self.sessionTaskCreator dataTaskWithSession:[self currentSession]
                                          HTTPMethod:method
                                                 URL:URL
                                          parameters:parameters
                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                       NSError *serializeError;
                                       id responseObject = [self.responseSerializer responseObjectForResponse:response data:data error:&serializeError];
                                       completionHandler(task, responseObject, serializeError);
                                   }];
    [task resume];
    return task;
}

- (NSURLSessionUploadTask *)loadUploadTaskWithURL:(NSURL *)URL
                                       parameters:(NSDictionary *)parameters
                                             data:(NSData *)data
                                completionHandler:(void (^)(NSURLSessionTask *task, id responseObject, NSError *error))completionHandler
{
    __block NSURLSessionUploadTask *task;
    if (_configuration.identifier) {
        NSError *fileWriteError;
        NSURL *fileURL = [self.temporaryFileManager createFileWithData:data error:&fileWriteError];
        task = [self.sessionTaskCreator
            uploadTaskInBackgroundWithSession:[self currentBackgroundSessionWithCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                  NSError *serializeError;
                                                  id responseObject =
                                                      [self.responseSerializer responseObjectForResponse:response data:data error:&serializeError];
                                                  completionHandler(task, responseObject, serializeError);
                                                  NSError *filerRemoveError;
                                                  [self.temporaryFileManager removeFileAtURL:fileURL error:&filerRemoveError];
                                              }]
                                          URL:URL
                                   parameters:parameters
                                      fileURL:fileURL];

    } else {
        task = [self.sessionTaskCreator uploadTaskWithSession:[self currentSession]
                                                          URL:URL
                                                   parameters:parameters
                                                         data:data
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                NSError *serializeError;
                                                id responseObject =
                                                    [self.responseSerializer responseObjectForResponse:response data:data error:&serializeError];
                                                completionHandler(task, responseObject, serializeError);
                                            }];
    }
    [task resume];
    return task;
}

- (NSURLSessionDownloadTask *)loadDownloadTaskWithURL:(NSURL *)URL
                                           parameters:(NSDictionary *)parameters
                                    completionHandler:(void (^)(NSURL *fileURL, NSURLResponse *response, NSError *error))completionHandler
{
    NSURLSessionDownloadTask *task =
        [self.sessionTaskCreator downloadTaskWithSession:[self currentSession] URL:URL parameters:parameters completionHandler:completionHandler];
    [task resume];
    return task;
}

- (NSURLSession *)currentSession
{
    if (_session) {
        return _session;
    }
    return _session = [NSURLSession sessionWithConfiguration:_configuration delegate:_sessionDelegateComposer delegateQueue:_delegateQueue];
}

- (NSURLSession *)currentBackgroundSessionWithCompletionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    // NOTE: NSURLSession's session delegate property has copy attributes.
    //       Then, this update completionHandler in this place.
    _sessionDelegateComposer.backgroundCompletionHandler = completionHandler;
    if (_session) {
        return _session;
    }
    return _session = [NSURLSession sessionWithConfiguration:_configuration delegate:_sessionDelegateComposer delegateQueue:_delegateQueue];
}

@end
