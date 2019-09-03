# DryAWSS3-iOS
iOS: 亚马逊AWSS3简化集成(文件上传)
[官网](https://us-east-1.signin.aws.amazon.com)
[Github](https://github.com/aws-amplify/aws-sdk-ios)


## Prerequisites
* iOS 10.0+
* ObjC、Swift


## Installation
* pod 'DryAWSS3-iOS'
* 请到官网注册并下载对应的 "awsconfiguration.json" 文件并导入工程中

## Features
### 上传文件
```
NSMutableArray<NSData *> *datas = [[NSMutableArray alloc] init];
UIImage *img1 = [UIImage imageNamed:@"1"];
NSData *data1 = UIImagePNGRepresentation(img1);
UIImage *img2 = [UIImage imageNamed:@"2"];
NSData *data2 = UIImagePNGRepresentation(img2);
[datas addObject:data1];
[datas addObject:data2];

NSMutableArray<NSString *> *keys = [[NSMutableArray alloc] init];
[keys addObject:[NSUUID UUID].UUIDString];
[keys addObject:[NSUUID UUID].UUIDString];
NSLog(@"-------------------------------");
NSLog(@"原始key集合: %@", keys);

NSString *bucket = @"";
NSString *folder = @"";
NSString *contentType = @"";
[DryAWSS3 uploadFilesWithDatas:datas keys:keys bucket:bucket folder:folder contentType:contentType progressHandler:^(NSString * _Nonnull currentKey, int64_t currentCount, int64_t currentCompleted, int64_t totalCount, int64_t totalCompleted) {
    NSLog(@"-------------------------------");
    NSLog(@"当前任务key: %@", currentKey);
    NSLog(@"当前任务总大小: %lld", currentCount);
    NSLog(@"当前任务已完成大小: %lld", currentCompleted);
    NSLog(@"所有任务总大小: %lld", totalCount);
    NSLog(@"所有任务已完成大小: %lld", totalCompleted);
} completionHandler:^(BOOL success, NSArray<NSString *> * _Nullable successKeys, NSArray<NSString *> * _Nullable failKeys, NSArray<NSString *> * _Nullable totalKeys) {
    NSLog(@"-------------------------------");
    NSLog(@"是否成功: %d", success);
    NSLog(@"成功的keys: %@", successKeys);
    NSLog(@"失败的keys: %@", failKeys);
    NSLog(@"所有的keys: %@", totalKeys);
}];
```
