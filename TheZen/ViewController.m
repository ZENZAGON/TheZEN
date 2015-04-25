//
//  ViewController.m
//  TheZen
//
//  Created by saito.minori on 2015/04/25.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import "ViewController.h"
#import "ZENDeviceManager.h"
#import <MEMELib/MEMELib.h>

@interface ViewController () <ZENDeviceObserver>

@property (nonatomic, retain) ZENDeviceManager *devMan;
@property (nonatomic) ZENDeviceStatus devStatus;
//@property (nonatomic, retain) ZENDeviceInfo *devInfo;

@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _devMan = [[ZENDeviceManager alloc] init];
        _devStatus = ZEN_DEVICE_STATUS_STOPPED;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //_devMan = [[ZENDeviceManager alloc] init];
    //_devStatus = ZEN_DEVICE_STATUS_STOPPED;
    //MEMELib *memeLib = [MEMELib sharedInstance];
    //_devMan.memeLib = memeLib;
    [_devMan connect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)zenDeviceStatus:(ZENDeviceStatus)status {
    _devStatus = status;
    _deviceStatusLabel.text = [NSString stringWithFormat:@"%d", status];
    if (status == ZEN_DEVICE_STATUS_RUNNING) {
        [_devMan start];
    }
}

- (void)zenDeviceInfo:(ZENDeviceInfo *)devInfo {
    //_devInfo.deviceId = devInfo.deviceId;
    _deviceIdLabel.text = devInfo.deviceId;
}

- (IBAction)start:(id)sender {
    [_devMan ready:3];
}

@end
