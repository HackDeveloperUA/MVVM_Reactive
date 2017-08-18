//
//  WorkerCell.m
//  MVVM_NonReactive
//
//  Created by Uber on 08/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "WorkerCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ANHelperFunctions/ANHelperFunctions.h>

@implementation WorkerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cvPhotoImageView.layer.masksToBounds = YES;
        _cvPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}


- (void)bindWithViewModel:(ViewModel_Worker_Cell *)vm
{
    
    ANDispatchBlockToMainQueue(^{
        RAC(_fullNameLabel, text) = [vm.fullNameSignal takeUntil:self.rac_prepareForReuseSignal];
        RAC(_postLabel,     text) = [vm.postTitleSignal takeUntil:self.rac_prepareForReuseSignal];
        
        
        // 2 - Вариант - Скачивание с помощью AFNetWorking
        RACSignal* urlImgSignal = vm.cvImageURLSignal;
        [urlImgSignal subscribeNext:^(NSString* urlString) {
            
            NSURL* url = [NSURL URLWithString:urlString];
            RACSignal* downloadImgSignal = [self downloadImageSignal:url];
            
            [[downloadImgSignal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIImage* img) {
                
                _cvPhotoImageView.layer.masksToBounds = YES;
                _cvPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
                _cvPhotoImageView.image = img;
                _cvPhotoImageView.layer.cornerRadius = CGRectGetWidth(_cvPhotoImageView.frame)/2;
                
            }];
        }];
    });
        
    _vmWorkerCell = vm;

    // 1 - Вариант - Скачивание с помощью стандартного NSURLConnection
    /*
     [vm.cvImageURLSignal subscribeNext:^(id x) {
     
         NSURL* url = [NSURL URLWithString:x];
         
         [[[self rac_imageWithURL:url] takeUntil:self.rac_prepareForReuseSignal] 
                                   subscribeNext:^(UIImage* img) {
         
          _cvPhotoImageView.layer.cornerRadius = img.size.width/36;
          _cvPhotoImageView.image = img;
         }];
     }];
     */
    
}

// 1 - Вариант - Скачивание с помощью стандартного NSURLConnection
- (RACSignal*)rac_imageWithURL:(NSURL*)url{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    return [[[NSURLConnection rac_sendAsynchronousRequest:request] map:^UIImage *(RACTuple* tuple) {
        return [UIImage imageWithData:tuple.second];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}


// 2 - Вариант - Скачивание с помощью AFNetWorking
-(RACSignal *)downloadImageSignal:(NSURL *)imageUrl {
    
      RACSignal* imageDownloadSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [_cvPhotoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:imageUrl]
                                 placeholderImage:[UIImage imageNamed:@"placeholder"]
                                          success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                              [subscriber sendNext:image];
                                              
                                          } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                              [subscriber sendError:error];
                                          }];
        return nil;
    }] subscribeOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]];
    
    return [imageDownloadSignal takeUntil:self.rac_prepareForReuseSignal];

}

@end

