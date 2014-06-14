//
//  AMEURLSessionDelegateComposer.m
//  AMEURLSession
//
//  Created by Satoshi Namai on 2014/05/25.
//  Copyright (c) 2014年 Satoshi Namai. All rights reserved.
//

#import "AMEURLSessionDelegateComposer.h"

@implementation AMEURLSessionDelegateComposer

- (instancetype)init
{
    return [self initWithDelegate:nil taskDelegate:nil dataDelegate:nil downloadDelegate:nil backgroundCompletionHandler:nil];
}

- (instancetype)initWithDelegate:(id<NSURLSessionDelegate>)delegate
                    taskDelegate:(id<NSURLSessionTaskDelegate>)taskDelegate
                    dataDelegate:(id<NSURLSessionDataDelegate>)dataDelegate
                downloadDelegate:(id<NSURLSessionDownloadDelegate>)downloadDelegate
     backgroundCompletionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))backgroundCompletionHandler
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.taskDelegate = taskDelegate;
        self.dataDelegate = dataDelegate;
        self.downloadDelegate = downloadDelegate;
        self.backgroundCompletionHandler = backgroundCompletionHandler;
    }
    return self;
}

- (instancetype)initWithBackgroundCompletionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))backgroundCompletionHandler
{
    return [self initWithDelegate:nil taskDelegate:nil dataDelegate:nil downloadDelegate:nil backgroundCompletionHandler:backgroundCompletionHandler];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (_taskDelegate) {
        [_taskDelegate URLSession:session task:task didCompleteWithError:error];
    }
    if (_backgroundCompletionHandler) {
        _backgroundCompletionHandler(nil, task.response, error);
        _backgroundCompletionHandler = nil;
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    if (_dataDelegate) {
        [_dataDelegate URLSession:session dataTask:dataTask didReceiveData:data];
    }
}

- (void)URLSession:(NSURLSession *)session
                        task:(NSURLSessionTask *)task
             didSendBodyData:(int64_t)bytesSent
              totalBytesSent:(int64_t)totalBytesSent
    totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    if (_taskDelegate) {
        [_taskDelegate URLSession:session task:task didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
    }
}

- (void)URLSession:(NSURLSession *)session
          downloadTask:(NSURLSessionDownloadTask *)downloadTask
     didResumeAtOffset:(int64_t)fileOffset
    expectedTotalBytes:(int64_t)expectedTotalBytes
{
    if (_downloadDelegate) {
        [_downloadDelegate URLSession:session downloadTask:downloadTask didResumeAtOffset:fileOffset expectedTotalBytes:expectedTotalBytes];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    if (_downloadDelegate) {
        [_downloadDelegate URLSession:session downloadTask:downloadTask didFinishDownloadingToURL:location];
    }
}

- (void)URLSession:(NSURLSession *)session
                 downloadTask:(NSURLSessionDownloadTask *)downloadTask
                 didWriteData:(int64_t)bytesWritten
            totalBytesWritten:(int64_t)totalBytesWritten
    totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if (_downloadDelegate) {
        [_downloadDelegate URLSession:session
                         downloadTask:downloadTask
                         didWriteData:bytesWritten
                    totalBytesWritten:totalBytesWritten
            totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithDelegate:self.delegate
                                                  taskDelegate:self.taskDelegate
                                                  dataDelegate:self.dataDelegate
                                              downloadDelegate:self.downloadDelegate
                                   backgroundCompletionHandler:self.backgroundCompletionHandler];
}

@end
