//
//  WorkerBigName_Cell.m
//  MVVM_NonReactive
//
//  Created by Uber on 14/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "WorkerBigName_Cell.h"

// ViewModels
#import "ViewModel_WorkerBigName_Cell.h"

// Fraemworks
#import <AFNetworking/UIImage+AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation WorkerBigName_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Bindings

- (void)bindWithViewModel:(ViewModel_WorkerBigName_Cell *)vm
{
    RACScheduler* mainThreadScheduler = [RACScheduler mainThreadScheduler];
    
    RAC(self.fullNameLabel, text) = [[vm.fullNameSignal takeUntil:self.rac_prepareForReuseSignal] deliverOn:mainThreadScheduler];
    
    RAC(self.postInCompnayLabel, text) = [[vm.postTitleSignal takeUntil:self.rac_prepareForReuseSignal] deliverOn:mainThreadScheduler];

}

@end
