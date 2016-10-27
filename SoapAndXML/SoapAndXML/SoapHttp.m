//
//  SoapHttp.m
//  MIkeCRM
//
//  Created by zhouzhongmao on 16/5/26.
//  Copyright © 2016年 zhouzhongmao. All rights reserved.
//

#import "SoapHttp.h"
#import "AFNetworking.h"


@implementation SoapHttp

+ (void)POST:(NSString*)urlString methodName:(NSString *)methodName SoapMessage:(NSString *)soapMessage  Namespace:(NSString *)nameSpace success:(SucessBlcokType)success failure:(FailedBlockType)failure {

    NSString *msgLength = [NSString stringWithFormat:@"%zd",[soapMessage length]];
    
    
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    [manager setSecurityPolicy:securityPolicy];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@%@",nameSpace,methodName] forHTTPHeaderField:@"SOAPAction"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapMessage;
    }];
    
    [manager POST:urlString parameters:soapMessage  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];


}

@end
