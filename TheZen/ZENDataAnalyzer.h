//
//  ZENDataAnalyzer.h
//  TheZen
//
//  Created by 文 光石 on 2015/04/26.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZENDATA.h"

@interface ZENConfig : NSObject

@property float calibrationRoll;
@property float calibrationPitch;
@property float calibrationRaw;

@property float thresholdRoll;
@property float thresholdPitch;
@property float thresholdYaw;

@property signed char thresholdAccX;
@property signed char thresholdAccY;
@property signed char thresholdAccZ;

@end

@interface ZENDataAnalyzer : NSObject

- (void)setupConfig:(ZENConfig *)config;
- (BOOL)checkCalibrationData:(MEMERealTimeData *)data;
- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data;
- (BOOL)checkReceivedData:(MEMERealTimeData *)data;

@end
