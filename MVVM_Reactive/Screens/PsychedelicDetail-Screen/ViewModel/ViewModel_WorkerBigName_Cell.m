//
//  ViewModel_WorkerBigName_Cell.m
//  MVVM_NonReactive
//
//  Created by Uber on 14/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "ViewModel_WorkerBigName_Cell.h"

// Model
#import "WorkerFull.h"

@implementation ViewModel_WorkerBigName_Cell

#pragma mark - Init methods

- (instancetype)initWithWorker:(WorkerFull*) worker
{
    self = [super init];
    if (self) {
        
        self.model   = worker;
        self.fullNameTitle = [NSString stringWithFormat:@"%@ %@", _model.firstName, _model.lastName];
        self.postInCompany = _model.postInCompany;
    }
    return self;
}


#pragma mark - Setters

-(void) setModel:(WorkerFull *)model
{
    _model = model;
    [self bindSignals];
}


#pragma mark - Binding methods

- (void)bindSignals
{
    RACSignal *workerSingal = [RACSignal return: self.model];
    
    self.fullNameSignal = [workerSingal map:^id(WorkerFull* worker) {
        return [NSString stringWithFormat:@"%@ %@",worker.firstName, worker.lastName];
    }];
    
    self.postTitleSignal = [workerSingal map:^id(WorkerFull* worker) {
        return worker.postInCompany;
    }];
}

@end
