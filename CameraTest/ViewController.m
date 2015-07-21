//
//  ViewController.m
//  CameraTest
//
//  Created by 徳弘佑衣 on 2015/07/14.
//  Copyright (c) 2015年 徳弘佑衣. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)doCamera:(id)sender {
    
    UIImagePickerControllerSourceType sourceType;
    sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // カメラやフォトライブラリが使用できなければ、何もせずに戻る
    if ( ! [UIImagePickerController isSourceTypeAvailable:sourceType] ) {
        return;
        
    }
    // カメラを起動する
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    [ipc setSourceType:sourceType];
    [ipc setDelegate:self];
    [self presentViewController:ipc animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 撮影画像を取得
    self.imagePicture.image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // カメラUIを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)drawMeganeImage:(CIFaceFeature *)faceFeature
{
    // ２枚目以降のときのためにカエル画像を消す
    for (UIView *view in [self.imagePicture subviews]) {
        [view removeFromSuperview];
    }
    
    if (faceFeature.hasLeftEyePosition && faceFeature.hasRightEyePosition && faceFeature.hasMouthPosition) {
        
        // 顔のサイズ情報を取得
        CGRect faceRect = [faceFeature bounds];
        // 写真の向きで検出されたXとYを逆さにセットする
        float temp = faceRect.size.width;
        faceRect.size.width = faceRect.size.height;
        faceRect.size.height = temp;
        temp = faceRect.origin.x;
        faceRect.origin.x = faceRect.origin.y;
        faceRect.origin.y = temp;
        
        // 比率計算
        float widthScale = self.imagePicture.frame.size.width /self.imagePicture.image.size.width;
        float heightScale = self.imagePicture.frame.size.height /self.imagePicture.image.size.height;
        // 画像のxとy、widthとheightのサイズを比率似合わせて変更
        faceRect.origin.x *= widthScale;
        faceRect.origin.y *= heightScale;
        faceRect.size.width *= widthScale;
        faceRect.size.height *= heightScale;
        
        // UIImageViewを作成
        UIImage *kImage = [UIImage imageNamed:@"kaeru.png"];
        UIImageView *kImageView = [[UIImageView alloc]initWithImage:kImage];
        kImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        // 画像のリサイズ
        kImageView.frame = faceRect;
        
        // レイヤを撮影した写真に重ねる
        [self.imagePicture addSubview:kImageView];
    }
}


- (IBAction)doStamp:(id)sender {
    // 検出器生成
    NSDictionary *options = [NSDictionary dictionaryWithObject:CIDetectorAccuracyLow forKey:CIDetectorAccuracy];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
    
    // 検出
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:self.imagePicture.image.CGImage];
    NSDictionary *imageOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:6] forKey:CIDetectorImageOrientation];
    NSArray *array = [detector featuresInImage:ciImage options:imageOptions];
    
    // 検出されたデータを取得
    for (CIFaceFeature *faceFeature in array) {
        // 画像追加処理へ
        [self drawMeganeImage:faceFeature];
    }
}

//保存のところはあとで追加
//- (IBAction)doSave:(id)sender {
//    UIImageWriteToSavedPhotosAlbum(self.imagePicture.image, self,@selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:), nil);
//}
//
//-(void)savingImageIsFinished:(UIImage*)image
//    didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
//    
//        // Alertを表示する
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                      message:@"アルバムへ保存しました" delegate:nil
//                            cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        [alert show];
//    
//}

@end
