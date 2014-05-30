//
//  AMEURLSessionTaskCreator.h
//  AMEURLSession
//
//  Created by Satoshi Namai on 2014/05/25.
//  Copyright (c) 2014年 Satoshi Namai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMEURLRequestSerialization.h"

@interface AMEURLSessionTaskCreator : NSObject

@property (nonatomic, strong) id<AMEURLRequestSerialization> requestSerializer;

- (instancetype)initWithRequestSerializer:(id<AMEURLRequestSerialization>)requestSerializer;

- (NSURLSessionDataTask *)dataTaskWithSession:(NSURLSession *)session
                                   HTTPMethod:(NSString *)method
                                          URL:(NSURL *)URL
                                   parameters:(NSDictionary *)parameters
                            completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

- (NSURLSessionUploadTask *)uploadTaskWithSession:(NSURLSession *)session
                                              URL:(NSURL *)URL
                                       parameters:(NSDictionary *)parameters
                                             data:(NSData *)data
                                completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

- (NSURLSessionUploadTask *)uploadTaskInBackgroundWithSession:(NSURLSession *)session
                                                          URL:(NSURL *)URL
                                                   parameters:(NSDictionary *)parameters
                                                      fileURL:(NSURL *)fileURL;

- (NSURLSessionDownloadTask *)downloadTaskWithSession:(NSURLSession *)session
                                                  URL:(NSURL *)URL
                                           parameters:(NSDictionary *)parameters
                                    completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler;

- (NSURLRequest *)requestWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters;

@end
