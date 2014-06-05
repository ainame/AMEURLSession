//
//  AMEURLResponseSerialization.m
//  AMEURLSession
//
//  Created by Satoshi Namai on 2014/05/28.
//  Copyright (c) 2014年 Satoshi Namai. All rights reserved.
//

#import "AMEURLResponseSerialization.h"

@implementation AMEURLResponseHTTPResponseSerializer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stringEncoding = NSUTF8StringEncoding;
    }
    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    return data;
}

@end

@implementation AMEURLResponseJSONSResponSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    NSStringEncoding stringEncoding = self.stringEncoding;
    if (response.textEncodingName) {
        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)response.textEncodingName);
        if (encoding != kCFStringEncodingInvalidId) {
            stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
        }
    }

    if (data && [data length] > 0) {
        NSError *serializeError;
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&serializeError];
    }
    return nil;
}

@end
