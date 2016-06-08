//
//  LBMapHelper.h
//  mapTest
//
//  Created by fami_Lbb on 16/5/30.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBMapHelper : NSObject

- (void)myLocationWithLatitude:(float)latitude Longitude:(float)longitude;

- (void)baiduMapDestinationWithLatitude:(float)latitude Longitude:(float)longitude appScheme:(NSString *)appScheme;


@end
