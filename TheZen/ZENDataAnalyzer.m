//
//  ZENDataAnalyzer.m
//  TheZen
//
//  Created by 文 光石 on 2015/04/26.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import "ZENDataAnalyzer.h"


@implementation ZENConfig


@end


@interface ZENDataAnalyzer ()

@property (nonatomic) ZENConfig *config;
@property (nonatomic) BOOL isFirstData;

@property (nonatomic) ZENData *firstData;
@property (nonatomic) ZENData *currentData;
@property (nonatomic) ZENData *lastData;

@end

@implementation ZENDataAnalyzer

- (id)init
{
    if (self = [super init]) {
        _config = [[ZENConfig alloc] init];
        _firstData = [[ZENData alloc] init];
        _currentData = [[ZENData alloc] init];
        _lastData = [[ZENData alloc] init];
    }
    
    return self;
}

- (void)setupConfig:(ZENConfig *)config
{
    _config.thresholdRoll = config.thresholdRoll;
    _config.thresholdPitch = config.thresholdPitch;
    _config.thresholdYaw = config.thresholdYaw;
    _config.thresholdAccX = config.thresholdAccX;
    _config.thresholdAccY = config.thresholdAccY;
    _config.thresholdAccZ = config.thresholdAccZ;
}

- (BOOL)checkCalibrationData:(MEMERealTimeData *)data
{
    BOOL ret = YES;
    
    float calibrationRoll = fabs(data.roll);
    float calibrationPitch = fabs(data.pitch);
    float calibrationYaw = fabs(data.yaw);
    NSLog(@"===calibrationRoll = %f calibrationPitch = %f calibrationYaw = %f", calibrationRoll, calibrationPitch, calibrationYaw);
    
    if (calibrationRoll > _config.calibrationRoll ||
        calibrationPitch > _config.calibrationPitch ||
        calibrationYaw > _config.calibrationRaw) {
        ret = NO;
    } else {
        if (_isFirstData == YES) {
            [_firstData copyData:data];
            _isFirstData = NO;
        }
    }
    
    return ret;
}

- (void)memeRealTimeModeDataReceived: (MEMERealTimeData *)data
{
    /*if (_isFirstData == YES) {
        [_firstData copyData:data];
        _isFirstData = NO;
    }*/
    [_currentData copyData:data];
}

- (BOOL)checkReceivedData:(MEMERealTimeData *)data
{
    BOOL ret = YES;
    
    [_currentData copyData:data];
    
    float subRoll = fabs(_currentData.roll - _firstData.roll);
    float subPitch = fabs(_currentData.pitch - _firstData.pitch);
    float subYaw = fabs(_currentData.yaw - _firstData.yaw);
    int subAccX = abs(_currentData.accX - _firstData.accX);
    int subAccY = abs(_currentData.accY - _firstData.accY);
    int subAccZ = abs(_currentData.accZ - _firstData.accZ);
    
    NSLog(@"===subRoll = %f subPitch = %f subYaw = %f subAccX = %d subAccY = %d subAccZ = %d", subRoll, subPitch, subYaw, subAccX, subAccY, subAccZ);
    
    if ( subRoll > _config.thresholdRoll ||
         subPitch > _config.thresholdPitch ||
         subYaw > _config.thresholdYaw /*||
         subAccX > _config.thresholdAccX ||
         subAccY > _config.thresholdAccY ||
         subAccZ > _config.thresholdAccZ*/) {
        ret = NO;
        
        NSLog(@"*********************NG*********************");
    }
    
    return ret;
}

@end
