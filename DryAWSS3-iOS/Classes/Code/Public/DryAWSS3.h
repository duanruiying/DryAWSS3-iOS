//
//  DryAWSS3.h
//  DryAWSS3
//
//  Created by Ruiying Duan on 2019/5/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Block
/// 任务进度回调(当前任务key，当前任务大小Bytes，当前任务已完成大小Bytes，所有任务大小Bytes，所有任务已完成大小Bytes)
typedef void (^BlockDryAWSS3Progress) (NSString *currentKey,
                                       int64_t currentCount,
                                       int64_t currentCompleted,
                                       int64_t totalCount,
                                       int64_t totalCompleted);
/// 任务完成回调(是否成功，已完成的任务key的集合，失败的任务key的集合，所有任务key的集合)
typedef void (^BlockDryAWSS3completion) (BOOL success,
                                         NSArray<NSString *> *_Nullable successKeys,
                                         NSArray<NSString *> *_Nullable failKeys,
                                         NSArray<NSString *> *_Nullable totalKeys);

#pragma mark - DryAWSS3
@interface DryAWSS3 : NSObject

/// @说明 上传文件到AWSS3
/// @注释 文件类型必须相同，datas和keys数量必须一致
/// @参数 datas:              文件数据集合
/// @参数 keys:               文件唯一标识集合
/// @参数 bucket:             AWSS3配置的bucket
/// @参数 folder:             AWSS3配置的bucket下的子目录
/// @参数 contentType:        文件类型(如: "image/png"、"image/jpeg")
/// @参数 progressHandler:    进度回调(当前任务的key，当前任务的进度，所有任务的进度)
/// @参数 completionHandler:  完成回调(是否成功、返回的文件唯一标识集合)
/// @返回 void
+ (void)uploadFilesWithDatas:(NSArray<NSData *> *)datas
                        keys:(NSArray<NSString *> *)keys
                      bucket:(NSString *)bucket
                      folder:(NSString *)folder
                 contentType:(NSString *)contentType
             progressHandler:(BlockDryAWSS3Progress)progressHandler
           completionHandler:(BlockDryAWSS3completion)completionHandler;

@end

NS_ASSUME_NONNULL_END
