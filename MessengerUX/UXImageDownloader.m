//
//  UXImageDownloader.m
//  MessengerUX
//
//  Created by CPU11815 on 4/19/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXImageDownloader.h"
#import "UXImageCache.h"

#import "AFURLSessionManager.h"

static void * AFTaskCountOfBytesSentContext = &AFTaskCountOfBytesSentContext;
static void * AFTaskCountOfBytesReceivedContext = &AFTaskCountOfBytesReceivedContext;

@interface ProcessObseve : NSObject

@property (nonatomic) void * indentify;
@property (nonatomic) dispatch_queue_t dispatchQueue;
@property (nonatomic) ASImageDownloaderProgress processCallBackBlock;

- initWithIdentify:(void *)indentify callBackQueue:(dispatch_queue_t)callBackqueue downloadProcess:(ASImageDownloaderProgress) downloadProcess;

@end

@implementation ProcessObseve

- initWithIdentify:(void *)indentify callBackQueue:(dispatch_queue_t)callBackqueue downloadProcess:(ASImageDownloaderProgress) downloadProcess {
    self = [super init];
    if (self) {
        self.indentify = indentify;
        self.dispatchQueue = callBackqueue;
        self.processCallBackBlock = downloadProcess;
    }
    return self;
}

@end

@implementation UXImageDownloader

- (instancetype)init {
    NSURLSessionConfiguration *defaultConfiguration = [self.class defaultURLSessionConfiguration];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:defaultConfiguration];
    sessionManager.responseSerializer = [AFImageResponseSerializer serializer];
    
    // Replace with custom cache
    return [self initWithSessionManager:sessionManager
                 downloadPrioritization:AFImageDownloadPrioritizationFIFO
                 maximumActiveDownloads:4
                             imageCache:[[UXImageCache alloc] initWithMemoryCapacity:50 * 1024 * 1024 preferredMemoryCapacity:40 * 1024 * 1024]];
}

// This dummy is overiding parent method, because parent method is private
+ (NSURLSessionConfiguration *)defaultURLSessionConfiguration {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //TODO set the default HTTP headers
    
    configuration.HTTPShouldSetCookies = YES;
    configuration.HTTPShouldUsePipelining = NO;
    
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    configuration.allowsCellularAccess = YES;
    configuration.timeoutIntervalForRequest = 60.0;
    configuration.URLCache = [AFImageDownloader defaultURLCache];
    
    return configuration;
}

#pragma mark - ASImageDownloaderProtocol

- (nullable id)downloadImageWithURL:(NSURL *)URL
                      callbackQueue:(dispatch_queue_t)callbackQueue
                   downloadProgress:(nullable ASImageDownloaderProgress)downloadProgress
                         completion:(ASImageDownloaderCompletion)completion {
    
    NSURLRequest * request = [NSURLRequest requestWithURL:URL];
    
    AFImageDownloadReceipt * receipt = [self downloadImageForURLRequest:request success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
        
        dispatch_async(callbackQueue ? callbackQueue : dispatch_get_main_queue(), ^{
            if (completion) {
                completion(responseObject, nil, nil);
            }
        });
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        dispatch_async(callbackQueue ? callbackQueue : dispatch_get_main_queue(), ^{
            if (completion) {
                completion(nil, error, nil);
            }
        });
        
    }];
    
    if (downloadProgress) {
//        [self setProgressWithDownloadProgressOfTask:(NSURLSessionDownloadTask *)receipt.task callBackQueue:callbackQueue downloadProcess:downloadProgress];
    }
    
    return receipt;
}

- (void)cancelImageDownloadForIdentifier:(id)downloadIdentifier {
    AFImageDownloadReceipt * receipt = downloadIdentifier;
    
    [self cancelTaskForImageDownloadReceipt:receipt];
}

//// implement this thing to set piority for AFNetworking downloader
//- (void)setPriority:(ASImageDownloaderPriority)priority withDownloadIdentifier:(id)downloadIdentifier {
//    
////    AFImageDownloadReceipt * receipt = downloadIdentifier;
//    
//    switch (priority) {
//        case ASImageDownloaderPriorityPreload: {
//            
//            break;
//        }
//        case ASImageDownloaderPriorityImminent: {
//            
//            break;
//        }
//        case ASImageDownloaderPriorityVisible: {
//            
//            break;
//        }
//    }
//}

//#pragma mark - Task process manager
//
//- (void)setProgressWithUploadProgressOfTask:(NSURLSessionUploadTask *)task
//                              callBackQueue:(dispatch_queue_t)callBackqueue
//                            downloadProcess:(ASImageDownloaderProgress) downloadProcess {
//    
//    void * contextState = (__bridge void *)([[ProcessObseve alloc] initWithIdentify:AFTaskCountOfBytesSentContext callBackQueue:callBackqueue downloadProcess:downloadProcess]);
//    void * contextSent = (__bridge void *)([[ProcessObseve alloc] initWithIdentify:AFTaskCountOfBytesSentContext callBackQueue:callBackqueue downloadProcess:downloadProcess]);
//    
//    [task addObserver:self forKeyPath:@"state" options:(NSKeyValueObservingOptions)0 context:contextState];
//    [task addObserver:self forKeyPath:@"countOfBytesSent" options:(NSKeyValueObservingOptions)0 context:contextSent];
//}
//
//- (void)setProgressWithDownloadProgressOfTask:(NSURLSessionDownloadTask *)task
//                                callBackQueue:(dispatch_queue_t)callBackqueue
//                              downloadProcess:(ASImageDownloaderProgress) downloadProcess {
//    
//    void * contextState = (__bridge void *)([[ProcessObseve alloc] initWithIdentify:AFTaskCountOfBytesReceivedContext callBackQueue:callBackqueue downloadProcess:downloadProcess]);
//    void * contextReceived = (__bridge void *)([[ProcessObseve alloc] initWithIdentify:AFTaskCountOfBytesReceivedContext callBackQueue:callBackqueue downloadProcess:downloadProcess]);
//    
//    [task addObserver:self forKeyPath:@"state" options:(NSKeyValueObservingOptions)0 context:contextState];
//    [task addObserver:self forKeyPath:@"countOfBytesReceived" options:(NSKeyValueObservingOptions)0 context:contextReceived];
//}
//
//#pragma mark - NSKeyValueObserving
//
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(__unused NSDictionary *)change
//                       context:(void *)context
//{
//    
//    ProcessObseve * pContext = (__bridge ProcessObseve *)(context);
//    
//    if (pContext.indentify == AFTaskCountOfBytesSentContext || pContext.indentify == AFTaskCountOfBytesReceivedContext) {
//        if ([keyPath isEqualToString:NSStringFromSelector(@selector(countOfBytesSent))]) {
//            if ([object countOfBytesExpectedToSend] > 0) {
//                
//                if (pContext.processCallBackBlock) {
//                    CGFloat progess = [object countOfBytesSent] / ([object countOfBytesExpectedToSend] * 1.0f);
//                    dispatch_async(pContext.dispatchQueue ? pContext.dispatchQueue : dispatch_get_main_queue(), ^{
//                        pContext.processCallBackBlock(progess);
//                    });
//                }
//            }
//        }
//        
//        if ([keyPath isEqualToString:NSStringFromSelector(@selector(countOfBytesReceived))]) {
//            if ([object countOfBytesExpectedToReceive] > 0) {
//                
//                if (pContext.processCallBackBlock) {
//                    CGFloat progess = [object countOfBytesReceived] / ([object countOfBytesExpectedToReceive] * 1.0f);
//                    dispatch_async(pContext.dispatchQueue ? pContext.dispatchQueue : dispatch_get_main_queue(), ^{
//                        pContext.processCallBackBlock(progess);
//                    });
//                }
//            }
//        }
//        
//        if ([keyPath isEqualToString:NSStringFromSelector(@selector(state))]) {
//            if ([(NSURLSessionTask *)object state] == NSURLSessionTaskStateCompleted) {
//                @try {
//                    [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(state))];
//                    
//                    if (pContext.indentify == AFTaskCountOfBytesSentContext) {
//                        [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesSent))];
//                    }
//                    
//                    if (pContext.indentify == AFTaskCountOfBytesReceivedContext) {
//                        [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesReceived))];
//                    }
//                }
//                @catch (NSException * __unused exception) {}
//            }
//        }
//    }
//}

@end
