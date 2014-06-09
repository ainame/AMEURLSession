//
//  AMEURLRequestSerializer.h
//  AMEURLSession
//
//  Created by Satoshi Namai on 2014/05/27.
//  Copyright (c) 2014年 Satoshi Namai. All rights reserved.
//

#import <Foundation/Foundation.h>

// NOTE: this protocol have comaptibility to AFURLRequestSerialization protocol
@protocol AMEURLRequestSerialization <NSObject>

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request withParameters:(id)parameters error:(NSError *__autoreleasing *)error;

@end

@interface AMEURLRequestHTTPRequestSerializer : NSObject <AMEURLRequestSerialization>

@end
