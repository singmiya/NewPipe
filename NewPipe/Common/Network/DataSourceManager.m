//
//  DataSourceManager.m
//  NewPipe
//
//  Created by Somiya on 2018/10/14.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "DataSourceManager.h"
#import "AFNetworking.h"

@interface DataSourceManager()

@end
@implementation DataSourceManager

+ (instancetype)sharedInstance {
    static DataSourceManager *singleton = nil;
    static dispatch_once_t onceToken;
    // dispatch_once  无论使用多线程还是单线程，都只执行一次
    dispatch_once(&onceToken, ^{
        singleton = [DataSourceManager new];
    });
    return singleton;
}

- (void)post:(NSString *)url params:(NSDictionary *)params success:(SuccessCallBack)successCallBack failure:(FailureCallBack)failureCallBack {
    // 1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    // 2.发送GET请求
    /**
     GET: NSString类型的请求路径，AFN内部会自动将该路径包装为一个url并创建请求对象
     parameters: 请求参数，以字典的方式传递，AFN内部会判断当前是POST请求还是GET请求，
     以选择直接拼接还是转换为NSData放到请求体中传递.
     progress: 进度回调,此处为nil
     success: 请求成功之后回调Block
     task: 请求任务、
     responseObject: 响应体信息（内部已编码处理JSON->OC对象）
     failure: 失败回调（error:错误信息）
     task.response: 响应头
     */
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successCallBack(responseObject);
        NSLog(@"%@\n%@",task.response,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureCallBack(error);
        NSLog(@"%@",error);
    }];
}

- (void)get:(NSString *)url params:(NSDictionary *)params success:(SuccessCallBack)successCallBack failure:(FailureCallBack)failureCallBack {
    // 1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    // 2.发送GET请求
    /**
     GET: NSString类型的请求路径，AFN内部会自动将该路径包装为一个url并创建请求对象
     parameters: 请求参数，以字典的方式传递，AFN内部会判断当前是POST请求还是GET请求，
     以选择直接拼接还是转换为NSData放到请求体中传递.
     progress: 进度回调,此处为nil
     success: 请求成功之后回调Block
     task: 请求任务、
     responseObject: 响应体信息（内部已编码处理JSON->OC对象）
     failure: 失败回调（error:错误信息）
     task.response: 响应头
     */
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successCallBack(responseObject);
//        NSLog(@"%@\n%@",task.response,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureCallBack(error);
//        NSLog(@"%@",error);
    }];
}
@end
