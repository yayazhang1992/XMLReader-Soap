//
//  SoapHttp.h
//  MIkeCRM
//
//  Created by zhouzhongmao on 16/5/26.
//  Copyright © 2016年 zhouzhongmao. All rights reserved.
//

#import <Foundation/Foundation.h>

//成功的回调blcok
typedef void(^SucessBlcokType)(id response);
//失败的回调的blcok
typedef void(^FailedBlockType)(NSError *error);

@interface SoapHttp : NSObject

+ (void)POST:(NSString*)urlString methodName:(NSString *)methodName SoapMessage:(NSString *)soapMessage Namespace:(NSString *)nameSpace success:(SucessBlcokType)success failure:(FailedBlockType)failure;

@end
