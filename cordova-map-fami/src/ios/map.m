/********* map.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "LBMapHelper.h"

@interface map : CDVPlugin

@property(nonatomic,strong)NSString *latitude;
@property(nonatomic,strong)NSString *longitude;

- (void)coolMethod:(CDVInvokedUrlCommand*)command;
@end

@implementation map

-(void)pluginInitialize{
    
    CDVViewController *viewController = (CDVViewController *)self.viewController;
    
        self.latitude = [viewController.settings objectForKey:@"latitude"];
        self.longitude = [viewController.settings objectForKey:@"longitude"];

}


- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    //获取本项目的bounldID 和 productName
    NSString *bounleID = [[NSBundle mainBundle]bundleIdentifier];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    
    NSString *appSchmem = [NSString stringWithFormat:@"%@://%@",app_Name,bounleID];
    
    CGFloat latitude = [self.latitude floatValue];
    CGFloat longitude = [self.longitude floatValue];
    
    [self drawOPtionsWithLatitude:latitude Longitude:longitude appScheme:appSchmem];

}


- (void)drawOPtionsWithLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude appScheme:(NSString *)appScheme{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择要使用的地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *localMap = [UIAlertAction actionWithTitle:@"本机地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [[LBMapHelper new]myLocationWithLatitude:latitude Longitude:longitude ];
        
    }];
    
    
    UIAlertAction *baiDuMap = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [[LBMapHelper new]baiduMapDestinationWithLatitude:latitude Longitude:longitude appScheme:appScheme];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alert addAction:localMap];
    [alert addAction:baiDuMap];
    [alert addAction:cancel];
    
    [self.viewController presentViewController:alert animated:YES completion:nil];
    
}

@end
