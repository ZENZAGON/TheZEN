//
//  ViewController.h
//  TheZen
//
//  Created by saito.minori on 2015/04/25.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel  *deviceIdLabel;
@property (weak, nonatomic) IBOutlet UILabel  *deviceStatusLabel;

- (IBAction)start:(id)sender;

@end

