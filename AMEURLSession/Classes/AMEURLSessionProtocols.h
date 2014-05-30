//
//  AMEURLSessionProtocols.h
//  AMEURLSession
//
//  Created by Satoshi Namai on 2014/05/31.
//  Copyright (c) 2014年 ainame. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMETemporaryFileManaging <NSObject>

- (NSURL *)createFileWithData:(NSData *)data error:(NSError **)error;

- (BOOL)removeFileAtURL:(NSURL *)URL error:(NSError **)error;

@end
