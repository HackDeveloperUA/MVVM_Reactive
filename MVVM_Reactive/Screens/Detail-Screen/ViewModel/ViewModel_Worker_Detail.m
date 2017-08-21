//
//  DetailController_VM.m
//  MVVM_NonReactive
//
//  Created by Uber on 09/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "ViewModel_Worker_Detail.h"

// Models
#import "WorkerFull.h"
#import "PhotoModel.h"

// Server API
#import "ServerManager.h"

// Router
#import "Router.h"



@implementation ViewModel_Worker_Detail


#pragma mark - Init methods

- (instancetype)initWithWorker:(WorkerFull*) worker
{
    self = [super init];
    if (self) {
        
        self.model = worker;
        
        self.fullNameTitle =  [NSString stringWithFormat:@"%@ %@",_model.firstName, _model.lastName];
        self.postTitle     = self.model.postInCompany;
        self.mainTextTitle = self.model.mainText;
        self.cvImageURL    = self.model.photoURL;
    }
    return self;
}


- (instancetype)initWithLinkOnFull_CV_Model:(NSString*) link
{
    self = [super init];
    if (self) {
        self.linkOnFullCV = link;
       }
    return self;
}



#pragma mark - Binding methods

- (void)bindSignals
{
    if (self.model)
    {
        @weakify(self);
        
#warning Почему он не работает ? В классе ViewModel_Worker_Cell в методе bindSignals, используется точно такой же подход, только там работает, а тут нет ...
        
        // Первый способ. - Не работает
        /*
        RACSignal *workerSingal = [RACSignal return: self.model];
       
        self.fullName_Signal = [workerSingal map:^NSString*(WorkerFull* worker) {
            return [NSString stringWithFormat:@"%@ %@",worker.firstName, worker.lastName];
        }];
        self.postTitle_Signal = [workerSingal map:^NSString*(WorkerFull* worker) {
            return worker.postInCompany;
        }];
        self.mainText_Signal = [workerSingal map:^NSString*(WorkerFull* worker) {
            return worker.postInCompany;
        }];
        */
        
        
        // Второй способ. - Не работает
        /*
        RACChannelTo(self, fullNameTitle) = RACChannelTo(self.model, firstName);
        RACChannelTo(self, postTitle)     = RACChannelTo(self.model, postInCompany);
        RACChannelTo(self, mainTextTitle) = RACChannelTo(self.model, mainText);
        */

        
        // Третий способ. - Не работает
        /*
        RACChannelTerminal *channelA = RACChannelTo(self, fullNameTitle);
        RACChannelTerminal *channelB = RACChannelTo(self.model, firstName);
        [channelA subscribe: channelB];
        [channelB subscribe: channelA];
        */
        
        
        // Четвертый способ. - Не работает
        /*
        RAC(self, fullNameTitle) = RACObserve(self.model, firstName);
        RAC(self, postTitle)     = RACObserve(self.model, postInCompany);
        RAC(self, mainTextTitle) = RACObserve(self.model, mainText);
        */
        
        
        // Пятый способ.
        /*
        RAC(self, fullNameTitle) = [RACSignal combineLatest:@[RACObserve(self.model, firstName),
                                                              RACObserve(self.model, lastName)]
                                                     reduce:^id(id fName, id lName){
                                                         NSLog(@"id fName, id lName = %@ %@",fName,lName);
                                                         return [NSString stringWithFormat:@"%@ %@",fName, lName];
                                                     }];
        RAC(self,postTitle)     = RACObserve(self.model, postInCompany);
        RAC(self,mainTextTitle) = RACObserve(self.model, mainText);
        RAC(self,cvImageURL)    = RACObserve(self.model, photoURL);
        */


        // Шестой способ
        [[RACSignal combineLatest:@[RACObserve(self.model, firstName),
                                   RACObserve(self.model, lastName)]
                          reduce:^id(id fName, id lName){
                              NSLog(@"reduuce = %@", [NSString stringWithFormat:@"%@ %@",fName, lName]);
                              return [NSString stringWithFormat:@"%@ %@",fName, lName];
                          }] subscribeNext:^(id x) {
                              @strongify(self);
                              NSLog(@"subscribeNext = %@",x);
                              self.fullNameTitle = x;
                          }];
        [RACObserve(self.model, postInCompany) subscribeNext:^(id x) {
            @strongify(self);
            self.postTitle = x;
        }];
        [RACObserve(self.model, mainText) subscribeNext:^(id x) {
            @strongify(self);
            self.mainTextTitle = x;
        }];
        [RACObserve(self.model, photoURL) subscribeNext:^(id x) {
            @strongify(self);
            self.cvImageURL = x;
        }];
    }
}



#pragma mark - UI Handlers

- (void) openImgCVonFullScreenWithPhotoModel:(id<NYTPhoto>) model
{
    [[Router sharedRouter] openNYTPhotovVCwithPhotoModel:model];
}

- (void) goToPscychedelicTVC_Clicked
{
    [[Router sharedRouter] openPsychedelicDetailTVC:self.model];
}

#pragma mark - API

- (RACSignal*) get_FullWorkerModelByLink:(NSString*) link
{
    return  [[ServerManager sharedManager] getFullInfoByWorkers:link];
}


#pragma mark - Setters

- (void) setLinkOnFullCV:(NSString *)linkOnFullCV
{
    _linkOnFullCV = linkOnFullCV;
    [[self get_FullWorkerModelByLink:linkOnFullCV] subscribeNext:^(WorkerFull* x) {
        
        self.model = x;
        self.fullNameTitle = x.firstName;
    }];
}

- (void) setModel:(WorkerFull *)model
{
    _model = model;
    [self bindSignals];
}

@end
