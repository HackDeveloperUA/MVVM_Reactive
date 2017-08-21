//
//  DetailVC.m
//  MVVM_NonReactive
//
//  Created by Uber on 08/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "DetailVC.h"

// Network operation - Download image from internet
#import <AFNetworking/UIImage+AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

// Anthoer fraemworks
#import <ANHelperFunctions/ANHelperFunctions.h>
#import <NYTPhotoViewer/NYTPhotosViewController.h>

// Models
#import "PhotoModel.h"


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
    
    [self aroundView:self.cvImageView];
    [self addTapGestureOnUIView:self.cvImageView withTarget:self withSEL:@selector(tapGestureAction:)];
}


#pragma mark - Setters

- (void) setVmWorkerDetail:(ViewModel_Worker_Detail *)vmWorkerDetail
{
    _vmWorkerDetail = vmWorkerDetail;
    [self bindWithViewModel:vmWorkerDetail];
}


- (void)bindWithViewModel:(ViewModel_Worker_Detail *)vm
{
    @weakify(self);
   
    
    
    
    //------------------ Первый способ. - НЕ РАБОТАЕТ
    /*
    RAC(_fullNameLabel,      text) = vm.fullName_Signal;
    RAC(_postInCompanyLabel, text) = vm.postTitle_Signal;
    RAC(_mainTextLabel,      text) = vm.postTitle_Signal;
    */
    
    
    // Второй способ. - НЕ РАБОТАЕТ
    /*
    RACChannelTo(_fullNameLabel,      text) = RACChannelTo(self.vmWorkerDetail, fullNameTitle);
    RACChannelTo(_postInCompanyLabel, text) = RACChannelTo(self.vmWorkerDetail, postTitle);
    RACChannelTo(_mainTextLabel,      text) = RACChannelTo(self.vmWorkerDetail, mainTextTitle);
     */
    
    
    //------------------ Третий Способ. - НЕ РАБОТАЕТ
    /*
    RACChannelTerminal *channelA = RACChannelTo(self.fullNameLabel, text);
    RACChannelTerminal *channelB = RACChannelTo(self.vmWorkerDetail, fullNameTitle);
    [channelA subscribe: channelB];
    [channelB subscribe: channelA];
    */
    
    
    //------------------ Четвертый способ. - НЕ РАБОТАЕТ
    /*
    RAC(self.fullNameLabel,      text) = RACObserve(self.vmWorkerDetail, fullNameTitle);
    RAC(self.postInCompanyLabel, text) = RACObserve(self.vmWorkerDetail, postTitle);
    RAC(self.mainTextLabel,      text) = RACObserve(self.vmWorkerDetail, mainTextTitle);
    */
    
    
    //------------------ Пятый способ. Полу-рабочий
    /*
    @weakify(self);
    [[RACObserve(self.vmWorkerDetail, fullNameTitle) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"Проблема в том, что сначала нам приходит полное инициалы, а потом только имя = %@",x);
        self.fullNameLabel.text = x;
    }];
    
    [[RACObserve(self.vmWorkerDetail, postTitle) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        @strongify(self);
        self.postInCompanyLabel.text = x;
    }];
    
    [[RACObserve(self.vmWorkerDetail, mainTextTitle) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        @strongify(self);
        self.mainTextLabel.text = x;
    }];
    
    
    [[RACObserve(self.vmWorkerDetail, cvImageURL) deliverOn:[RACScheduler mainThreadScheduler]]
    subscribeNext:^(id x) {
        RACSignal* downloadSignal = [self downloadImageSignal:[NSURL URLWithString:x] withImage:_cvImageView];
        [[downloadSignal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            @strongify(self);
            self.cvImageView.image = x;
            self.cvImageView.layer.masksToBounds = YES;
            self.cvImageView.layer.cornerRadius  = CGRectGetWidth(self.cvImageView.frame)/2;
        }];
    }];
    */
    
#warning  Во VM все отлично, сюда первый раз приходит тоже fullName, а потом неизвестно откуда приходит только firstName
    //------------------  Шестой способ - Тоже полурабочий
    [[RACObserve(self.vmWorkerDetail, fullNameTitle) deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         NSLog(@"Во viewModel привязка функционирует нормально. Приходит имя и фамилия. А сюда только имя = %@",x);
        self.fullNameLabel.text = x;
    }];
    
    
    [[RACObserve(self.vmWorkerDetail, postTitle) deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         self.postInCompanyLabel.text = x;
     }];
    
    [[RACObserve(self.vmWorkerDetail, mainTextTitle) deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         self.mainTextLabel.text = x;
     }];
    
    [[RACObserve(self.vmWorkerDetail, cvImageURL) deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.cvImageView setImageWithURL:[NSURL URLWithString:x]];
     }];
    
    
    [[RACObserve(self.vmWorkerDetail, fullNameTitle) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        self.title = x;
    }];
}


#pragma mark - Action

- (void)tapGestureAction:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[UIImageView class]]) {
        UIImageView* imgFromGesture = (UIImageView*)tap.view;
        PhotoModel* photo = [[PhotoModel alloc] initFromUIImage:imgFromGesture.image];
        [self.vmWorkerDetail openImgCVonFullScreenWithPhotoModel:photo];
    }
}


- (IBAction)goToPscychedelicTVC:(id)sender {
     [self.vmWorkerDetail goToPscychedelicTVC_Clicked];
}


#pragma mark - RACSignal helpers

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


#pragma mark - Others helpers

- (void) aroundView:(UIView*) view
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius  = CGRectGetWidth(view.frame)/2;
}

- (void) addTapGestureOnUIView:(UIView*) view withTarget:(id)target withSEL:(SEL)action
{
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapRecognizer.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tapRecognizer];
}

@end

