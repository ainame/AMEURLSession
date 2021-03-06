//
//  AMEURLSessionTaskCreator.m
//  AMEURLSession
//
//  Created by Satoshi Namai on 2014/05/25.
//  Copyright (c) 2014年 Satoshi Namai. All rights reserved.
//

#import "AMEURLSessionTaskCreator.h"
#import "AMEURLRequestSerialization.h"

@implementation AMEURLSessionTaskCreator

- (instancetype)initWithRequestSerializer:(id<AMEURLRequestSerialization>)requestSerializer
{
    self = [super init];
    if (self) {
        self.requestSerializer = requestSerializer;
    }
    return self;
}

- (NSURLSessionDataTask *)dataTaskWithSession:(NSURLSession *)session
                                   HTTPMethod:(NSString *)method
                                          URL:(NSURL *)URL
                                   parameters:(NSDictionary *)parameters
                            completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler
{
    NSURLRequest *request = [self requestWithURL:URL method:method parameters:parameters];
    return [session dataTaskWithRequest:request completionHandler:completionHandler];
}

- (NSURLSessionUploadTask *)uploadTaskWithSession:(NSURLSession *)session
                                              URL:(NSURL *)URL
                                       parameters:(NSDictionary *)parameters
                                             data:(NSData *)data
                                completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler
{
    NSURLRequest *request = [self requestWithURL:URL method:@"POST" parameters:parameters];
    return [session uploadTaskWithRequest:request fromData:data completionHandler:completionHandler];
}

/// completionHandler must be set to the delegate object
- (NSURLSessionUploadTask *)uploadTaskInBackgroundWithSession:(NSURLSession *)session
                                                          URL:(NSURL *)URL
                                                   parameters:(NSDictionary *)parameters
                                                      fileURL:(NSURL *)fileURL
{
    NSURLRequest *request = [self requestWithURL:URL method:@"POST" parameters:parameters];
    return [session uploadTaskWithRequest:request fromFile:fileURL];
}

- (NSURLSessionDownloadTask *)downloadTaskWithSession:(NSURLSession *)session
                                                  URL:(NSURL *)URL
                                           parameters:(NSDictionary *)parameters
                                    completionHandler:(void (^)(NSURL *, NSURLResponse *, NSError *))completionHandler
{
    NSURLRequest *request = [self requestWithURL:URL method:@"GET" parameters:parameters];
    return [session downloadTaskWithRequest:request completionHandler:completionHandler];
}

- (NSURLRequest *)requestWithURL:(NSURL *)URL method:(NSString *)HTTPmethod parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    mutableRequest.HTTPMethod = HTTPmethod;

    NSError *serializeError;
    NSURLRequest *serializedRequest = [self.requestSerializer requestBySerializingRequest:mutableRequest withParameters:parameters error:&serializeError];
    if (serializeError) {
        return nil;
    }
    return serializedRequest;
}

@end
