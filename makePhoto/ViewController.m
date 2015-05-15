//
//  ViewController.m
//  makePhoto
//
//  Created by Binasystems on 5/12/15.
//  Copyright (c) 2015 Binasystems. All rights reserved.
//

#import "ViewController.h"
#import "AVFoundation/AVFoundation.h"
#import "CollectionCollectionViewCell.h"
#import  <Masonry/Masonry.h>

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) IBOutlet UIButton *takePictureButton;
@end

@implementation ViewController
AVCaptureSession *session;
AVCaptureStillImageOutput *stillImageOutput;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageArray = [NSMutableArray new];
    [self.collectionView reloadData];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"CollectionCollectionViewCell"];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.mas_equalTo(130);
        make.bottom.equalTo(self.view);
    }];

    
    [self.takePictureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(118);
        make.height.mas_equalTo(118);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     session=[[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    }
         AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
         [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
         CALayer *rootLayer=[[self view] layer];
         [rootLayer setMasksToBounds:YES];
         CGRect frame=self.frameForCapture.frame;
         [previewLayer setFrame:frame];
    
    [rootLayer insertSublayer:previewLayer atIndex:0];
    stillImageOutput=[[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings=[[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    [session addOutput:stillImageOutput];
    [session startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender
{
    AVCaptureConnection *videoConnection=nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType ] isEqual:AVMediaTypeVideo]) {
                videoConnection=connection;
                break;
            }
        }
        
        if (videoConnection) {
            
            break;
        }
    }
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer !=NULL) {
            NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image=[UIImage imageWithData:imageData];
          
            [self.imageArray addObject:image];
            [self.collectionView reloadData];
        }
    }];
        
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CollectionCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCollectionViewCell" forIndexPath:indexPath];

  //  cell.backgroundColor = [UIColor redColor];
   UIImage *img = self.imageArray[indexPath.row];
   cell.imageView.image = img;
//    

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = self.imageArray[indexPath.row];
    NSData *imageData = UIImageJPEGRepresentation(image ,1.0);

    MFMailComposeViewController *mailController=[[MFMailComposeViewController alloc]init];
    [mailController setMailComposeDelegate:self];
//    NSString *adress=[NSArray arrayWithObject:@"stefan@mail.moldovan"];
    [mailController addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"screen"];
//    [mailController setToRecipients:adress];
    [mailController setMessageBody:@"MessageHere" isHTML:NO];
    [mailController setSubject:@"subject"];
    [mailController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:mailController animated:YES completion:nil];
    
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

