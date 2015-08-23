//
//  AppDelegate.h
//  AWSVideoTest
//
//  Created by Mohamed Adly on 8/23/15.
//  Copyright (c) 2015 Mohamed Adly. All rights reserved.
//

#import <UIKit/UIKit.h>

//Amazon
#import "AWSS3.h"

#warning Fill with your info
#define AWS_REGION AWSRegionUSEast1
#define AWS_COG_ID @""
#define AWS_BUCKET_IN @""
#define AWS_BUCKET_OUT @""



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

