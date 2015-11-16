//
//  StudentDeskCell.h
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-26.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentDeskCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *numberOfDisruptionsLabel;

@property (strong, nonatomic) IBOutlet UILabel *studentNameLabel;


@property (strong, nonatomic) IBOutlet UILabel *numberOfGoodsLabel;

@property (strong, nonatomic) IBOutlet UILabel *badPressLabel;

@property (strong, nonatomic) IBOutlet UILabel *goodPressLabel;


@end
