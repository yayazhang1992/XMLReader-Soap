//
//  ViewController.m
//  SoapAndXML
//
//  Created by zhen zhu wang on 16/10/8.
//  Copyright © 2016年 zhen zhu wang. All rights reserved.
//

#import "ViewController.h"
#import "SoapHttp.h"
#import "XMLReader.h"

//iOS_解析XML（很实用的两框架：KissXML、XmlReader）
 //  http://www.jianshu.com/p/2eb1c93d75bb


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor yellowColor];
}


- (IBAction)readerBtn:(UIButton *)sender {
    
    //同步
    // [self testSyn];
    //异步
    [self testAsyn];

    
}



- (void)testSyn  {
    
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [[NSDate alloc]init];
    NSString *dataStr = [formate stringFromDate:date];
    NSLog(@"%@",dataStr);
    
    // 测试数据80009526
    
    
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<Third_Vip_Query xmlns=\"http://tempuri.org/\">"
                                   "<vipcode>%@</vipcode>"
                                   "<vipcardno>%@</vipcardno>"
                                   "<Phone>%@</Phone>"
                                   "<date>%@</date>"
                                   "<vipid>%@</vipid>"
                                   "</Third_Vip_Query>",
                                   @"80009526",@"",@"",dataStr,@""];//这里是参数
    
    
    NSString *webServiceStr = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                               "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                               "<soap:Body>\n"
                               "%@\n"
                               "</soap:Body>\n"
                               "</soap:Envelope>",
                               webServiceBodyStr];//webService头
    
    NSString *SOAPActionStr = [NSString stringWithFormat:@"%@%@", @"http://tempuri.org/",@"Third_Vip_Query"];//SOAPAction
    NSURL * url = [NSURL URLWithString:@"http://183.221.125.234:2180/webservice_JLC/vip_service.asmx?op=Third_Vip_Query"];
    NSMutableURLRequest *theRequest= [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *msgLength = [NSString stringWithFormat:@"%ld", webServiceStr.length];
    [theRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-type"];
    [theRequest addValue:SOAPActionStr forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[webServiceStr dataUsingEncoding:NSUTF8StringEncoding]];
    //发起请求
    //响应
    NSURLResponse *response = nil;
    //存放错误信息
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    
    if (error != nil) {
        NSLog(@"请求失败, 错误信息 %@",error);
        
    }else {
        NSLog(@"请求成功, 响应信息 %@",response);
        NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"cccccccccccccc   %@",result);
    }
    
}



- (void)testAsyn {
    
    
    
    
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [[NSDate alloc]init];
    NSString *dataStr = [formate stringFromDate:date];
    NSLog(@"%@",dataStr);
    
    // 测试数据80009526
    
    
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<Third_Vip_Query xmlns=\"http://tempuri.org/\">"
                                   "<vipcode>%@</vipcode>"
                                   "<vipcardno>%@</vipcardno>"
                                   "<Phone>%@</Phone>"
                                   "<date>%@</date>"
                                   "<vipid>%@</vipid>"
                                   "</Third_Vip_Query>",
                                   @"80009526",@"",@"",dataStr,@""];//这里是参数
    
    
    NSString *webServiceStr = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                               "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                               "<soap:Body>\n"
                               "%@\n"
                               "</soap:Body>\n"
                               "</soap:Envelope>",
                               webServiceBodyStr];//webService头
    
    [SoapHttp POST:@"http://183.221.125.234:2180/webservice_JLC/vip_service.asmx?op=Third_Vip_Query" methodName:@"Third_Vip_Query" SoapMessage:webServiceStr Namespace:@"http://tempuri.org/" success:^(id response) {
        
        NSString *result  =[[ NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"cccccccccccccc   %@",result);
        NSError *error;
        NSDictionary *dic = [XMLReader dictionaryForXMLData:response error:&error];
        NSDictionary *enve = dic[@"soap:Envelope"];
        NSDictionary *body = enve[@"soap:Body"];
        NSDictionary *response1 = body[@"Third_Vip_QueryResponse"];
        NSDictionary *queryResult = response1[@"Third_Vip_QueryResult"];
        NSLog(@"11%@",queryResult);
        NSString *errorStr = queryResult[@"error"][@"text"];
        NSLog(@"22%@",errorStr);
        
        
    } failure:^(NSError *error) {
        NSLog(@"错错错错错错错错错错错错%@",error);
    }];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
