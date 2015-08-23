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
{
    //URL for the recorded video
    NSURL *videoURL;
    NSString *videoFileName;
}

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

- (IBAction)uploadButtonClicked:(id)sender
{
    if (videoURL)
    {
        //Show HUD
        [SVProgressHUD showWithStatus:@"Uploading to S3"];
        
        //Create upload request
        videoFileName = [[NSProcessInfo processInfo] globallyUniqueString];
        AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
        uploadRequest.body = videoURL;
        uploadRequest.key = videoFileName;
        uploadRequest.bucket = AWS_BUCKET_IN;
        
        
        //initiate upload ASYNC
        [self upload:uploadRequest];

    }
    else
    {
        showAlert(@"Error", @"Please select a video first.");
    }
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
                        showAlert(@"Sorry", @"Recording with camera is not supported by this device.");
                    }
                }
                else
                {
                    showAlert(@"Sorry", @"Recording with camera is not supported by this device.");
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
                    showAlert(@"Sorry", @"Photo Library is empty or not supported by this device.");
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

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    videoURL = info[UIImagePickerControllerMediaURL];
    if (videoURL)
    {
        [self.statusTextField setText:@"video is ready to upload."];
    }
    
    //Dismiss
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //Dismiss
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AWS

- (void)upload:(AWSS3TransferManagerUploadRequest *)uploadRequest
{
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    [[transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask *task) {
        if (task.error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.statusTextField setText:@" Upload Failed, check console..."];
            });
            NSLog(@"Upload Failed: [%@]", task.error);
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.statusTextField setText:@"Video Uploaded to S3, check console..."];
            });
        }
        
        if (task.result)
        {
            NSLog(@"Upload Result: [%@]", task.result);
        }
        
        //dismiss HUD
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        return nil;
    }];
}

@end
