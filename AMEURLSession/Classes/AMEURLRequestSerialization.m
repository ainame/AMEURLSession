//
//  AMEURLRequestSerializer.m
//  AMEURLSession
//
//  Created by Satoshi Namai on 2014/05/27.
//  Copyright (c) 2014年 Satoshi Namai. All rights reserved.
//

#import "AMEURLRequestSerialization.h"

@implementation AMEURLRequestHTTPRequestSerializer

static NSString *const kAMECharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";
static NSString *const kAMECharactersToLeaveUnescapedInQueryStringPairKey = @"[].";

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request withParameters:(id)parameters error:(NSError *__autoreleasing *)error
{
    if (!parameters) {
        return request;
    }

    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    NSString *query = [self queryStringWithParameters:parameters];

    if ([@[ @"GET", @"HEAD", @"DELETE" ] containsObject:request.HTTPMethod]) {
        mutableRequest.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [mutableRequest.URL absoluteString], query]];
    } else {
        mutableRequest.HTTPBody = [query dataUsingEncoding:NSUTF8StringEncoding];
    }

    return mutableRequest;
}

- (NSString *)queryStringWithParameters:(NSDictionary *)parameters
{
    NSMutableArray *keyValuePairs = [NSMutableArray array];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        NSString *valueString = [self.class queryValueStringWith:value];
        [keyValuePairs
            addObject:[NSString stringWithFormat:@"%@=%@", [self.class encodeQueryKeyWithString:key], [self.class encodeQueryValueWithString:valueString]]];
    }];
    return [keyValuePairs componentsJoinedByString:@"&"];
}

+ (NSString *)encodeQueryKeyWithString:(NSString *)string
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
        kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAMECharactersToLeaveUnescapedInQueryStringPairKey,
        (__bridge CFStringRef)kAMECharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

+ (NSString *)encodeQueryValueWithString:(NSString *)string
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL,
                                                                                 (__bridge CFStringRef)kAMECharactersToBeEscapedInQueryString,
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

+ (NSString *)queryValueStringWith:(id)value
{
    return [value description];
}

@end
