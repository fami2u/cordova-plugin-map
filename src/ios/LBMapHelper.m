//
//  LBMapHelper.m
//  mapTest
//
//  Created by fami_Lbb on 16/5/30.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "LBMapHelper.h"
//系统
#import <MapKit/MapKit.h>
//百度
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>


@interface LBMapHelper()<BMKGeoCodeSearchDelegate>

@property (nonatomic,strong)MKMapItem *mylocation;
@property (nonatomic,strong)BMKGeoCodeSearch *geocodesearch;
@property (nonatomic,strong)NSString *lastN;

@property (nonatomic,strong)NSString *addressCity;

@end

@implementation LBMapHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.geocodesearch.delegate = self;
        
    }
    return self;
}


- (void)dealloc{
    
    self.geocodesearch.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"dealloc");
}


//打开本地地图
- (void)myLocationWithLatitude:(float)latitude Longitude:(float)longitude{


    //获取当前的位置
    self.mylocation = [MKMapItem mapItemForCurrentLocation];
    
    //目的地位置
    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake(latitude, longitude);

    //目的地
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];
    
    toLocation.name = @"目的地";
    
    self.mylocation.name = @"我的位置";
    
    NSArray *items = [NSArray arrayWithObjects:self.mylocation,toLocation,nil];
    
    NSDictionary *opions = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeStandard],
                             MKLaunchOptionsShowsTrafficKey:@YES};
    
    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:opions];
    
}


//百度地图
- (void)baiduMapDestinationWithLatitude:(float)latitude Longitude:(float)longitude appScheme:(NSString *)appScheme{
    
    
    [self onClickReverseGeocodeWithLatitude:latitude Longitude:longitude];

    
    [[NSNotificationCenter defaultCenter]addObserverForName:@"baidu" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [self MapDestinationWithLatitude:latitude Longitude:longitude startN:@"我的位置"lastN:self.lastN appScheme:appScheme];
        
    }];
    
    
    [[NSNotificationCenter defaultCenter]addObserverForName:@"baiduFaile" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [self MapDestinationWithLatitude:latitude Longitude:longitude startN:@"我的位置"lastN:@"地图上的终点" appScheme:appScheme];
        
    }];



}


- (void)MapDestinationWithLatitude:(float)latitude Longitude:(float)longitude startN:(NSString *)startName lastN:(NSString *)lastName appScheme:(NSString *)appScheme{
    
        BMKOpenDrivingRouteOption *opt = [[BMKOpenDrivingRouteOption alloc] init];
        opt.appScheme = appScheme;
        //初始化起点节点
        BMKPlanNode* start = [[BMKPlanNode alloc]init];
        //指定起点经纬度
        CLLocationCoordinate2D coor1;
        coor1.latitude = 0;
        coor1.longitude = 0;
    
        //指定起点名称
        start.name = startName;
        //指定起点
        opt.startPoint = start;
    
        //初始化终点节点
        BMKPlanNode* end = [[BMKPlanNode alloc]init];
        CLLocationCoordinate2D coor2;
        coor2.latitude = latitude;
        coor2.longitude = longitude;
        end.pt = coor2;
    
        //指定终点名称
        end.name = lastName;
        end.cityName = @" ";
    
        opt.endPoint = end;
        BMKOpenErrorCode code = [BMKOpenRoute openBaiduMapDrivingRoute:opt];
        
        NSLog(@"%d", code);
    
        return;

}



//反向编码
- (void)onClickReverseGeocodeWithLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude{
    
    self.lastN = nil;
    
    self.addressCity = @" ";
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){latitude,longitude};
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    
    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    
    if (flag) {
        
        NSLog(@"反geo检索发送成功");
    }
    
    else{
        
        NSLog(@"反geo检索发送失败");
        
    }
    
}


#pragma mark ----BMKGeoCodeSearchDelegate----

//正向编码
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if (error == 0) {
        
        BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        
        NSLog(@"()()()()%@",item.title);
    }
}

//反向编码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == 0) {
        
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;

        NSString *city;
        NSString *address;
        
        city = result.addressDetail.city;
        
        address = [NSString stringWithFormat:@"%@",item.title];
        
        self.lastN = address;
        
        self.addressCity = city;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"baidu" object:nil];
        

    }else{
        
        NSLog(@"编码失败");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"baiduFaile" object:nil];

    }
    
}




#pragma mark ----lazylode----

- (BMKGeoCodeSearch *)geocodesearch{
    
    if (!_geocodesearch) {
        
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        
    }
    
    return _geocodesearch;
}



@end
