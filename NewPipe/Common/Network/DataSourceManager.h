//
//  DataSourceManager.h
//  NewPipe
//
//  Created by Somiya on 2018/10/14.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SuccessCallBack)(id response);
typedef void (^FailureCallBack)(id response);
@interface DataSourceManager : NSObject
+ (instancetype)sharedInstance;

- (void)post:(NSString *)url params:(NSDictionary *)param success:(SuccessCallBack)successCallBack failure:(FailureCallBack)failureCallBack;

- (void)get:(NSString *)url params:(NSDictionary *)params success:(SuccessCallBack)successCallBack failure:(FailureCallBack)failureCallBack;
@end
