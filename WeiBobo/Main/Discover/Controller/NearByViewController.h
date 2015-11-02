//
//  NearByViewController.h
//  WeiBobo
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NearByViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@end
