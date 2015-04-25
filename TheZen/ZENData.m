//
//  ZENData.m
//  TheZen
//
//  Created by 文 光石 on 2015/04/26.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import "ZENData.h"

@implementation ZENData

- (void)copyData:(MEMERealTimeData *)data
{
    self.roll = data.roll;
    self.pitch = data.pitch;
    self.yaw = data.yaw;
    self.accX = data.accX;
    self.accY = data.accY;
    self.accZ = data.accZ;
    
    NSLog(@"===roll = %f pitch = %f yaw = %f accX = %d accY = %d accZ = %d", self.roll, self.pitch, self.yaw, self.accX, self.accY, self.accZ);
}

@end
