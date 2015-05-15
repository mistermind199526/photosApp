//
//  ViewController.h
//  makePhoto
//
//  Created by Binasystems on 5/12/15.
//  Copyright (c) 2015 Binasystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *frameForCapture;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


- (IBAction)takePhoto:(id)sender;

@end

