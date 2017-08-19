//
//  DetailController_VM.m
//  MVVM_NonReactive
//
//  Created by Uber on 09/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "ViewModel_Worker_Detail.h"

#import "ServerManager.h"

#import "Router.h"

@implementation ViewModel_Worker_Detail


#pragma mark - Initis methods

- (instancetype)initWithWorker:(WorkerFull*) worker
{
    self = [super init];
    if (self) {
        
        _modelData = worker;
        
        self.fullNameTitle =  [NSString stringWithFormat:@"%@ %@",_modelData.firstName, _modelData.lastName];
        self.postTitle     = self.modelData.postInCompany;
        self.mainTextTitle = self.modelData.mainText;
        self.cvImageURL    = self.modelData.photoURL;
    }
    return self;
}


- (instancetype)initWithLinkOnFull_CV_Model:(NSString*) link
{
    NSLog(@" - (instancetype)initWithLinkOnFull_CV_Model:(NSString*) link ");
    self = [super init];
    if (self) {
        self.linkOnFullCV = link;
        //[self bindSignals];

        [[self getSignal_DetailWorkerModelFromServer:link] subscribeNext:^(id x) {
            
        }];
    }
    return self;
}

#pragma mark - Helpers

- (void) setModelData:(WorkerFull *)modelData
{
    NSLog(@" - (void) setModelData:(WorkerFull *)modelData ");
    _modelData = modelData;
    [self bindSignals];
}


#pragma mark - Binding methods
- (void)bindSignals
{
    NSLog(@" - (void)bindSignals. self.modelData = %@",self.modelData);
    
    RACSignal* workerSignal = [RACSignal return: self.modelData];
    
    self.fullName_Signal = [workerSignal map:^id(WorkerFull* worker) {
        return [NSString stringWithFormat:@"%@ %@",worker.firstName, worker.lastName];
    }];
    
    self.postTitle_Signal = [workerSignal map:^id(WorkerFull* worker) {
        return worker.postInCompany;
    }];
    
    
    self.cvImageURL_Signal = [workerSignal map:^id(WorkerFull* worker) {
        return worker.photoURL;
    }];
    
    self.mainText_Signal = [workerSignal map:^id(WorkerFull* worker) {
        return worker.mainText;
    }];
    
    self.linkOnFullCV_Signal = [workerSignal map:^id(WorkerFull* worker) {
        return worker.photoURL;
    }];
    
}


#pragma mark - UI Handlers

- (void) goToPscychedelicTVC_Clicked
{
    [[Router sharedRouter] openPsychedelicDetailTVC:self.modelData];
}


- (RACSignal*) getSignal_DetailWorkerModelFromServer:(NSString*) link
{
    NSLog(@"- (RACSignal*) getSignal_DetailWorkerModelFromServer:(NSString*) link");
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        @strongify(self);
        
        [[[ServerManager sharedManager] getFullInfoByWorkers:link] subscribeNext:^(WorkerFull* worker) {
            NSLog(@"LLLLLL   [[[ServerManager sharedManager] getFullInfoByWorkers:link]");
             self.modelData = worker;
            
            if (self.modelData)
                [subscriber sendNext:@(YES)];
            else
                [subscriber sendNext:@(NO)];
        
        } error:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}


@end
