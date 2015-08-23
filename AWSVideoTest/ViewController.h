//
//  ViewController.h
//  AWSVideoTest
//
//  Created by Mohamed Adly on 8/23/15.
//  Copyright (c) 2015 Mohamed Adly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define showAlert(title,msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show]


@interface ViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *selectVideoButton;


@property (weak, nonatomic) IBOutlet UITextField *statusTextField;


- (IBAction)selectVideoButtonClicked:(id)sender;

@end

