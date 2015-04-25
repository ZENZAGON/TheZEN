//
//  ZENDeviceManager.h
//  TheZen
//
//  Created by 文 光石 on 2015/04/26.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ZEN_DEVICE_STATUS_PERFECT           = 0,
    ZEN_DEVICE_STATUS_LEAN,
    ZEN_DEVICE_STATUS_CONNECTING,
    ZEN_DEVICE_STATUS_CONNECTED,
    //ZEN_DEVICE_STATUS_READY,
    //ZEN_DEVICE_STATUS_CALIBRATING,
    ZEN_DEVICE_STATUS_RUNNING,
    ZEN_DEVICE_STATUS_STOPPED,
    ZEN_DEVICE_STATUS_ERROR,
} ZENDeviceStatus;

@interface ZENDeviceInfo : NSObject

@property (nonatomic, copy) NSString *deviceId;

@end


@protocol ZENDeviceObserver <NSObject>

- (void)zenDeviceStatus:(ZENDeviceStatus)status;

@optional

- (void)zenDeviceInfo:(ZENDeviceInfo *)devInfo;

@end

@interface ZENDeviceManager : NSObject

@property (weak, nonatomic) id<ZENDeviceObserver> observer;

- (void)connect;
- (void)ready:(int)seconds;
- (void)start;
- (void)stop;

@end
