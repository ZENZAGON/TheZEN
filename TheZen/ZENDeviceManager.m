//
//  ZENDeviceManager.m
//  TheZen
//
//  Created by 文 光石 on 2015/04/26.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import "ZENDeviceManager.h"
#import "ZENDataAnalyzer.h"
#import <MEMELib/MEMELib.h>

#define ZEN_ID ""

typedef enum {
    ZEN_DEVICE_COMMAND_NONE   = 0,
    ZEN_DEVICE_COMMAND_READY,
    ZEN_DEVICE_COMMAND_START,
} ZENDeviceCommand;

@implementation ZENDeviceInfo


@end

@interface ZENDeviceManager() <MEMELibDelegate>

@property (nonatomic, retain) ZENDataAnalyzer *dataAnalyzer;
@property (nonatomic, strong) MEMELib *memeLib;
@property (nonatomic, copy) NSString *memeId;
@property (nonatomic, retain) CBPeripheral *meme;
@property (nonatomic) BOOL calibration;
@property (nonatomic) ZENDeviceStatus status;
@property (nonatomic) BOOL isReady;
@property (nonatomic) BOOL isStarted;
@property (nonatomic) ZENDeviceCommand command;

@end

@implementation ZENDeviceManager

- (id)init
{
    if (self = [super init]) {
        _dataAnalyzer = [[ZENDataAnalyzer alloc] init];
        _calibration = NO;
        _status = ZEN_DEVICE_STATUS_STOPPED;
        _isReady = NO;
        _isStarted = NO;
        _command = ZEN_DEVICE_COMMAND_NONE;
        
        _memeLib = [MEMELib sharedInstance];
        _memeLib.delegate = self;
        _memeId = @"3F3A322F-902B-AD7C-90F8-C571D2D28A4E";
        //[self.meme addObserver: self forKeyPath: @"centralManagerEnabled" options: NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

- (void)connect
{
    // Start Scanning
    MEMEStatus status = [_memeLib startScanningPeripherals];
    [self checkMEMEStatus: status];
    
    _status = ZEN_DEVICE_STATUS_CONNECTING;
    if (_observer != nil) {
        [_observer zenDeviceStatus:_status];
    }
}

- (void)ready:(int)seconds
{
    [self setupConfig];
    
    _command = ZEN_DEVICE_COMMAND_READY;
}

- (void)start
{
    _command = ZEN_DEVICE_COMMAND_START;
}

- (void)stop
{
    
}

- (void)setupConfig
{
    ZENConfig *config = [[ZENConfig alloc] init];
    config.calibrationRoll = 15;
    config.calibrationPitch = 15;
    config.calibrationRaw = 15;
    config.thresholdRoll = 10;
    config.thresholdPitch = 10;
    config.thresholdYaw = 10;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"keyPath %@", keyPath);
    if ([keyPath isEqualToString: @"centralManagerEnabled"]){
    }
}

- (BOOL)calibrateDevice: (MEMERealTimeData *) data
{
    BOOL ret = NO;
    
    return ret;
}

#pragma mark
#pragma mark MEMELib Delegates

- (void) memePeripheralFound: (CBPeripheral *) peripheral;
{
    NSLog(@"peripheral found %@", [peripheral.identifier UUIDString]);
    if (_memeLib.isConnected == NO) {
        if ([[peripheral.identifier UUIDString] compare:_memeId] == NSOrderedSame) {
            _meme = peripheral;
            NSLog(@"set meme %@", [peripheral.identifier UUIDString]);
        }
    }
}

- (void) memePeripheralConnected: (CBPeripheral *)peripheral
{
    NSLog(@"MEME Device Connected!(%@)", [peripheral.identifier UUIDString]);
    
    if ([[peripheral.identifier UUIDString] compare:_memeId] != NSOrderedSame) {
        [_memeLib disconnectPeripheral];
        return;
    }
    
    // Set Data Mode to Standard Mode
    [_memeLib changeDataMode: MEME_COM_REALTIME];
    
    if (_status == ZEN_DEVICE_STATUS_CONNECTING) {
        _status = ZEN_DEVICE_STATUS_CONNECTED;
        if (_observer != nil) {
            [_observer zenDeviceStatus:_status];
            ZENDeviceInfo *info = [[ZENDeviceInfo alloc] init];
            info.deviceId = [NSString stringWithFormat:@"(%@)%@", peripheral.name, [peripheral.identifier UUIDString]];
            [_observer zenDeviceInfo:info];
        }
    }
}

- (void) memePeripheralDisconnected: (CBPeripheral *)peripheral
{
    NSLog(@"MEME Device Disconnected!(%@)", [peripheral.identifier UUIDString]);
}


- (void) memeStandardModeDataReceived: (MEMEStandardData *) data
{
}


- (void) memeRealTimeModeDataReceived: (MEMERealTimeData *) data
{
    if (_command == ZEN_DEVICE_COMMAND_READY) {
        if (_calibration == NO) {
            if ([_dataAnalyzer checkCalibrationData:data]) {
                _calibration = YES;
                _status = ZEN_DEVICE_STATUS_RUNNING;
                if (_observer != nil) {
                    [_observer zenDeviceStatus:_status];
                }
            }
        }
    } else if (_command == ZEN_DEVICE_COMMAND_START) {
        if ([_dataAnalyzer checkReceivedData:data]) {
            _status = ZEN_DEVICE_STATUS_PERFECT;
        } else {
            _status = ZEN_DEVICE_STATUS_LEAN;
        }
        
        if (_observer != nil) {
            [_observer zenDeviceStatus:_status];
        }
    }
}

- (void) memeDataModeChanged:(MEMEDataMode)mode
{
    
    
}

- (void) memeAppAuthorized:(MEMEStatus)status
{
    [self checkMEMEStatus: status];
}

#pragma mark UTILITY

- (void) checkMEMEStatus: (MEMEStatus) status
{
    if (status == MEME_ERROR_APP_AUTH){
        NSLog(@"Status: App Auth Failed");
        //_status = ZEN_DEVICE_STATUS_ERROR;
    } else if (status == MEME_ERROR_SDK_AUTH){
        NSLog(@"Status: SDK Auth Failed");
        //_status = ZEN_DEVICE_STATUS_ERROR;
    } else if (status == MEME_OK){
        NSLog(@"Status: MEME_OK");
    }
}

@end
