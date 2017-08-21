//
//  WorkerRightAlignment_Cell.h
//  MVVM_NonReactive
//
//  Created by Uber on 14/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewModel_WorkerRightAlignment_Cell;

@interface WorkerRightAlignment_Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cvImgView;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postInCompnayLabel;

@property (weak, nonatomic) ViewModel_WorkerRightAlignment_Cell* vmWorkerCell; // link on cell ViewModel

#pragma mark - Bindings
- (void)bindWithViewModel:(ViewModel_WorkerRightAlignment_Cell *)vm;


@end
