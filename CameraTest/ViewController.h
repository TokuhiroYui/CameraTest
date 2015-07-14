//
//  ViewController.h
//  CameraTest
//
//  Created by 徳弘佑衣 on 2015/07/14.
//  Copyright (c) 2015年 徳弘佑衣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;
- (IBAction)doStamp:(id)sender;
- (IBAction)doCamera:(id)sender;


@end

