//
//  DetailVC.m
//  MVVM_NonReactive
//
//  Created by Uber on 08/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "DetailVC.h"

#import <AFNetworking/UIImage+AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

#import <ANHelperFunctions/ANHelperFunctions.h>


@interface DetailVC ()

@end

@implementation DetailVC

#pragma mark - Inits methods

- (instancetype)init
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    
    if (self) {
        
    }
    return self;
}


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    //self.fullNameLabel.text       = self.vmWorkerDetail.fullNameTitle;
    //self.postInCompanyLabel.text  = self.vmWorkerDetail.postTitle;
    //self.mainTextLabel.text       = self.vmWorkerDetail.mainTextTitle;
    /*
    NSURL* cvURL = [NSURL URLWithString: self.vmWorkerDetail.cvImageURL];
    
    [self.cvImageView setImageWithURLRequest:[NSURLRequest requestWithURL:cvURL] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
        self.cvImageView.image = image;
    
    } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
        NSLog(@"setImageWithURLRequest = %@\n Error = %@",response,error);
    }];
     */
    [self bindWithViewModel: _vmWorkerDetail];

}



#pragma mark - Action

- (IBAction)goToPscychedelicTVC:(id)sender {
    
    [self.vmWorkerDetail goToPscychedelicTVC_Clicked];
}


#pragma mark - Settets

- (void) setVmWorkerDetail:(ViewModel_Worker_Detail *)vmWorkerDetail {
    
    
    /*
     // NONE REACTIVE CODE
    [_vmWorkerDetail getDetailWorkerModelFromServer:_vmWorkerDetail.linkOnFullCV
                                     onSuccess:^(BOOL successOperation) {
                                         
                                         if (successOperation)
                                             [self setupUIwithSelfViewModel];
                                             
                                     } onFailure:^(NSError *errorBlock, NSInteger statusCode) {
                                        // Print error
                                         NSLog(@"errorBlock = %@",errorBlock);
                                     }];
    */
    /*
    @weakify(self);
    [[vmWorkerDetail getSignal_DetailWorkerModelFromServer:vmWorkerDetail.linkOnFullCV]
     subscribeNext:^(NSNumber* successOperation) {
         @strongify(self);

         if ([successOperation boolValue])
             [self setupUIwithSelfViewModel];

     } error:^(NSError *error) {
        
         NSLog(@"error = %@",error);
     }];
    
    _vmWorkerDetail = vmWorkerDetail;
    */
    
    
    @weakify(self);
    [[vmWorkerDetail getSignal_DetailWorkerModelFromServer:vmWorkerDetail.linkOnFullCV]
     subscribeNext:^(NSNumber* successOperation) {
         @strongify(self);
         
         //if ([successOperation boolValue])
             //[self bindWithViewModel: vmWorkerDetail];
         
     } error:^(NSError *error) {
         
         NSLog(@"error = %@",error);
     }];
    
    _vmWorkerDetail = vmWorkerDetail;
}

#pragma mark - UI Setting

- (void) setupUIwithSelfViewModel {
    /*
    self.fullNameLabel.text       = self.vmWorkerDetail.fullNameTitle;
    self.postInCompanyLabel.text  = self.vmWorkerDetail.postTitle;
    self.mainTextLabel.text       = self.vmWorkerDetail.mainTextTitle;
    

    NSURL* cvURL = [NSURL URLWithString: self.vmWorkerDetail.cvImageURL];
    
    [self.cvImageView setImageWithURLRequest:[NSURLRequest requestWithURL:cvURL] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
        self.cvImageView.image = image;
        
    } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
        NSLog(@"setImageWithURLRequest = %@\n Error = %@",response,error);
    }];
     */
}


- (void)bindWithViewModel:(ViewModel_Worker_Detail *)vm
{
    ANDispatchBlockToMainQueue(^{
       
        RAC(self.fullNameLabel, text) = vm.fullName_Signal;
        RAC(self.postInCompanyLabel, text) = vm.postTitle_Signal;
        RAC(self.mainTextLabel, text) = vm.mainText_Signal;
       
        RACSignal* urlImgSignal = vm.cvImageURL_Signal;
        [urlImgSignal subscribeNext:^(NSString* urlString) {
            
            NSURL* url = [NSURL URLWithString:urlString];
            RACSignal* downloadImgSignal = [self downloadImageSignal:url withImage:_cvImageView];
            
            [[downloadImgSignal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIImage* img) {
                
                _cvImageView.layer.masksToBounds = YES;
                _cvImageView.contentMode = UIViewContentModeScaleAspectFill;
                _cvImageView.image = img;
                _cvImageView.layer.cornerRadius = CGRectGetWidth(_cvImageView.frame)/2;
                
            }];
        }];

    });
    _vmWorkerDetail = vm;
}

// 2 - Вариант - Скачивание с помощью AFNetWorking
-(RACSignal *)downloadImageSignal:(NSURL *)imageUrl withImage:(UIImageView*) img{
    
    RACSignal* imageDownloadSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [img setImageWithURLRequest:[NSURLRequest requestWithURL:imageUrl]
                                 placeholderImage:[UIImage imageNamed:@"placeholder"]
                                          success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                              [subscriber sendNext:image];
                                              
                                          } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                              [subscriber sendError:error];
                                          }];
        return nil;
    }] subscribeOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]];
    
    return imageDownloadSignal;
    
}

@end

