##README
###此插件是关于跳转第三方地图进行导航的插件。使用者需要注意一下几点：
- 开发过程中可以通过调取 map.coolMethod( ); 成功调取跳转地图的方法。当然需要开发人员传递目的地位置的经纬度。插件的plugin.xml中已经留好接口，如下：

      <preference name="latitude" value= "$latitude"/>
      <preference name="longitude" value= "$longitude"/>

- 静态库中采用ObjectC++实现，因此需要您保证您工程中至少有一个.mm后缀的源文件(您可以将任意一个.m后缀的文件改名为.mm)，或者在工程属性中指定编译方式，即在Xcode的Project -> Edit Active Target -> Build Setting 中找到 Compile Sources As，并将其设置为"Objective-C++"

- 在AppDelegate中注册百度地图
  
    
        BMKMapManager* _mapManager; 
         _mapManager = [[BMKMapManager alloc]init];
        BOOL ret = [_mapManager start:@"应用注册的AK" generalDelegate:self];
        if (!ret) {
        NSLog(@"manager start failed");
      }
 
 
- 添加代理方便观察联网和授权状态
  
 
       #pragma mark BMKGeneralDelegate
       
        -  (void)onGetNetworkState:(int)iError{
        
        if (iError == 0) {
        NSLog(@"联网成功!");
        }else{
        NSLog(@"onGetNetWorkStare %d",iError); }
        
        }



       - (void)onGetPermissionState:(int)iError{
       if (iError == 0) {
        
        NSLog(@"授权成功!");
        }else{
        
        NSLog(@"onGetPermissionStare %d",iError);
    	}
    	}
    	
- 如果在iOS9中使用了调起百度地图客户端功能，必须在"Info.plist"中进行如下配置，否则不能调起百度地图客户端。

       <key>LSApplicationQueriesSchemes</key>
       <array>
         <string>baidumap</string>
       </array>
        
        
- 为了使用完地图之后跳转回到本应用，需要开发者在info.plist中添加appSchmem，需要添加URL Schemes的内容和对应的Identifier(填写项目名和对应的bounldId，否则不能跳回本项目)。            

