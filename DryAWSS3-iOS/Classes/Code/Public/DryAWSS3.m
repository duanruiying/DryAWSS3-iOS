//
//  DryAWSS3.m
//  DryAWSS3
//
//  Created by Ruiying Duan on 2019/5/18.
//

#import <AWSS3/AWSS3.h>
#import "DryAWSS3.h"

#pragma mark - DryAWSS3
@interface DryAWSS3()

@end

@implementation DryAWSS3

/// 单例
+ (instancetype)sharedInstance {
    
    static DryAWSS3 *theInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        theInstance = [[DryAWSS3 alloc] init];
    });
    
    return theInstance;
}

/// 构造
- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

/// 析构
- (void)dealloc {
    
}

/// 上传文件到AWSS3
+ (void)uploadFilesWithDatas:(NSArray<NSData *> *)datas
                        keys:(NSArray<NSString *> *)keys
                      bucket:(NSString *)bucket
                      folder:(NSString *)folder
                 contentType:(NSString *)contentType
             progressHandler:(BlockDryAWSS3Progress)progressHandler
           completionHandler:(BlockDryAWSS3completion)completionHandler {
    
    /// 检查数据
    if (!progressHandler || !completionHandler) {
        return;
    }
    
    /// 检查数据
    if (!datas || !datas.count || !keys || !keys.count || datas.count != keys.count) {
        completionHandler(NO, nil, nil, nil);
        return;
    }
    
    /// 检查数据
    if (!bucket || !folder || !contentType) {
        completionHandler(NO, nil, nil, nil);
        return;
    }
    
    /// 获取上传任务个数
    NSInteger taskCount = [datas count];
    
    /// 获取所有文件的大小(Bytes)
    int64_t totalCount = 0;
    for (NSInteger i = 0; i < taskCount; i++) {
        totalCount += datas[i].length;
    }
    
    /// [key: 当前任务已完成大小Bytes]
    NSMutableDictionary<NSString *, NSNumber *> *currentCompletedDict = [[NSMutableDictionary alloc] init];
    
    /// 配置进度回调(每个上传任务的进度都会在这里回调)
    AWSS3TransferUtilityUploadExpression *expression = [[AWSS3TransferUtilityUploadExpression alloc] init];
    expression.progressBlock = ^(AWSS3TransferUtilityTask * _Nonnull task, NSProgress * _Nonnull progress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /// 当前任务的key
            NSString *currentKey = [task key];
            
            /// 当前任务大小Bytes
            int64_t currentCount = [progress totalUnitCount];
            
            /// 当前任务已完成大小Bytes
            int64_t currentCompleted = [progress completedUnitCount];
            
            /// 检查回调的“当前任务已完成大小Bytes”是否更新
            if (![[currentCompletedDict allKeys] containsObject:currentKey]) {
                NSNumber *num = [[NSNumber alloc] initWithLongLong:currentCompleted];
                currentCompletedDict[currentKey] = num;
            }else {
                NSNumber *num = currentCompletedDict[currentKey];
                int64_t oldCurrentCompleted = num.longLongValue;
                if (oldCurrentCompleted < currentCompleted) {
                    NSNumber *num = [[NSNumber alloc] initWithLongLong:currentCompleted];
                    currentCompletedDict[currentKey] = num;
                }
            }
            
            /// 所有任务已完成大小Bytes
            int64_t totalCompleted = 0;
            for (NSString *dictKey in [currentCompletedDict allKeys]) {
                int64_t len = currentCompletedDict[dictKey].longLongValue;
                totalCompleted += len;
            }
            
            /// 回调
            progressHandler(currentKey, currentCount, currentCompleted, totalCount, totalCompleted);
        });
    };
    
    /// 配置任务完成回调(每完成一个上传任务回调一次)
    __block NSMutableArray<NSString *> *allKeys = [[NSMutableArray alloc] init];
    __block NSMutableArray<NSString *> *successKeys = [[NSMutableArray alloc] init];
    __block NSMutableArray<NSString *> *failKeys = [[NSMutableArray alloc] init];
    AWSS3TransferUtilityUploadCompletionHandlerBlock completion;
    completion = ^(AWSS3TransferUtilityUploadTask *task, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /// 保存key
            [allKeys addObject:task.key];
            if (!error) {
                [failKeys addObject:task.key];
            }else {
                [successKeys addObject:task.key];
            }
            
            /// 回调
            if (taskCount == allKeys.count) {
                
                /// 检查是否全部任务成功
                BOOL success = YES;
                if (taskCount != successKeys.count) {
                    success = NO;
                }
                
                /// 回调
                completionHandler(success, successKeys, failKeys, allKeys);
            }
        });
    };
    
    /// 启动上传任务
    AWSS3TransferUtility *transfer = [AWSS3TransferUtility defaultS3TransferUtility];
    for (NSInteger i = 0; i < taskCount; i++) {
        
        [transfer uploadData:datas[i]
                      bucket:bucket
                         key:keys[i]
                 contentType:contentType
                  expression:expression
           completionHandler:completion];
    }
}

@end
