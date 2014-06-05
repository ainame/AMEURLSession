//
//  AMEURLResponseSerialization.h
//  AMEURLSession
//
//  Created by Satoshi Namai on 2014/05/28.
//  Copyright (c) 2014年 Satoshi Namai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMEURLResponseSerialization <NSObject>

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error;

@end

@interface AMEURLResponseHTTPResponseSerializer : NSObject <AMEURLResponseSerialization>

@property (nonatomic, assign) NSStringEncoding stringEncoding;

@end

@interface AMEURLResponseJSONSResponSerializer : AMEURLResponseHTTPResponseSerializer

@end
