//
//  AMEURLRequestSerializer.h
//  AMEURLSession
//
//  Created by Satoshi Namai on 2014/05/27.
//  Copyright (c) 2014年 Satoshi Namai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMEURLRequestSerialization <NSObject>

- (NSURLRequest *)serializeRequest:(NSURLRequest *)request parameters:(NSDictionary *)parameters;

@end

@interface AMEURLRequestHTTPRequestSerializer : NSObject <AMEURLRequestSerialization>

@end
