//
//  AMESimpleTemporaryFileManager.m
//  AMEURLSession
//
//  Created by Satoshi Namai on 2014/05/27.
//  Copyright (c) 2014年 Satoshi Namai. All rights reserved.
//

#import "AMESimpleTemporaryFileManager.h"

@implementation AMESimpleTemporaryFileManager

static dispatch_queue_t temporaryFileQueue;

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ temporaryFileQueue = dispatch_queue_create("com.ainame.ameurlsession.temporaryfilemanager", DISPATCH_QUEUE_SERIAL); });
}

- (NSURL *)createFileWithData:(NSData *)data error:(NSError *__autoreleasing *)error
{
    NSURL *directoryURL = [self createTemporaryDirectory];
    NSString *fileName = [[[NSUUID alloc] init] UUIDString];
    NSURL *fileURL = [directoryURL URLByAppendingPathComponent:fileName];
    [data writeToURL:fileURL options:NSDataWritingAtomic error:error];
    return fileURL;
}

- (BOOL)removeFileAtURL:(NSURL *)URL error:(NSError *__autoreleasing *)error
{
    return [[NSFileManager defaultManager] removeItemAtURL:URL error:error];
}

- (NSURL *)createTemporaryDirectory
{
    NSURL *directoryURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[[NSUUID alloc] init] UUIDString]] isDirectory:YES];
    [[NSFileManager defaultManager] createDirectoryAtURL:directoryURL withIntermediateDirectories:YES attributes:nil error:nil];
    return directoryURL;
}

@end
