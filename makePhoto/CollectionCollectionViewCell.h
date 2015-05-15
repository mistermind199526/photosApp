//
//  CollectionCollectionViewCell.h
//  makePhoto
//
//  Created by Binasystems on 5/13/15.
//  Copyright (c) 2015 Binasystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> 

@interface CollectionCollectionViewCell : UICollectionViewCell <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
