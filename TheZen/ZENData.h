//
//  ZENData.h
//  TheZen
//
//  Created by 文 光石 on 2015/04/26.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MEMELib/MEMELib.h>

@interface ZENData : NSObject

@property float roll;
@property float pitch;
@property float yaw;

@property signed char accX;
@property signed char accY;
@property signed char accZ;

- (void)copyData:(MEMERealTimeData *)data;

@end
