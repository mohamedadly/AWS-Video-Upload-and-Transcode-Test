//
//  ViewController.m
//  AWSVideoTest
//
//  Created by Mohamed Adly on 8/23/15.
//  Copyright (c) 2015 Mohamed Adly. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Buttons Actions

- (IBAction)selectVideoButtonClicked:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Record", @"From Library", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        switch (buttonIndex)
        {
            case 0: //Record
            {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    NSArray *availableMediaTypes = [UIImagePickerController
                                                    availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                    if ([availableMediaTypes containsObject:(NSString *)kUTTypeMovie])
                    {
                        // Video recording is supported.
                        [self showPickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                    }
                    else
                    {
                        showAlert(@"Recording with camera is not supported by this device.", @"Sorry");
                    }
                }
                else
                {
                    showAlert(@"Recording with camera is not supported by this device.", @"Sorry");
                }
            }
                break;
            case 1: //Library
            {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    [self showPickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                }
                else
                {
                    showAlert(@"Photo Library is empty or not supported by this device.", @"Sorry");
                }
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - image picker

-(void)showPickerWithSourceType:(UIImagePickerControllerSourceType) type
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = type;
    picker.allowsEditing = NO;
    picker.mediaTypes = @[(NSString*)kUTTypeMovie];
    picker.delegate = self;
    picker.videoQuality = UIImagePickerControllerQualityType640x480;
    
    //Set rear camera by default if possible
    if(type == UIImagePickerControllerSourceTypeCamera)
    {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
        {
            [picker setCameraDevice:UIImagePickerControllerCameraDeviceRear];
        }
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

@end
