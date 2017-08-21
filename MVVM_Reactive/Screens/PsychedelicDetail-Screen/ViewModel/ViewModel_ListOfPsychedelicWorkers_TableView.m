//
//  ViewModel_ListOfPsychedelicWorkers_TableView.m
//  MVVM_NonReactive
//
//  Created by Uber on 14/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "ViewModel_ListOfPsychedelicWorkers_TableView.h"

// Cell VM
#import "ViewModel_BasedWorker_Cell.h"
#import "ViewModel_WorkerBigName_Cell.h"
#import "ViewModel_WorkerRightAlignment_Cell.h"
#import "ViewModel_WorkerLeftAlignment_Cell.h"

// Cell
#import "WorkerLeftAlignment_Cell.h"
#import "WorkerRightAlignment_Cell.h"
#import "WorkerBigName_Cell.h"


// Model
#import "WorkerFull.h"

// Router
#import "Router.h"


#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))


@implementation ViewModel_ListOfPsychedelicWorkers_TableView


#pragma mark - Init methods

- (instancetype)initWithWorker:(WorkerFull*) workerModel
{
    self = [super init];
    if (self) {
        self.vmForCellsArray = [NSMutableArray array];
        self.modelWorker = workerModel;
    }
    return self;
}


#pragma mark - Methods for TableView work

- (NSInteger) countWorkers {
    return self.vmForCellsArray.count;
}

- (ViewModel_BasedWorker_Cell*) cellViewModel:(NSInteger) index {
    if (index > self.vmForCellsArray.count){
        return nil;
    }
    return self.vmForCellsArray[index];
}



#pragma mark - Reactive API Method
- (RACSignal*) getSignal_generateVMforCells
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
        
        self.vmForCellsArray = [NSMutableArray arrayWithArray:[self generateVMforCells]];
      
        if (self.vmForCellsArray.count>0){
            [subscriber sendNext:@(YES)];
        } else{
            [subscriber sendNext:@(NO)];
        }
        
        return nil;
    }];
}


#pragma mark - None Reactive API Method

- (void) generateVMforCells:(void(^)(BOOL successOperation)) success
                  onFailure:(void(^)(NSError* errorBlock)) failure
{
    self.vmForCellsArray = [NSMutableArray arrayWithArray:[self generateVMforCells]];
    if (self.vmForCellsArray.count>0){
        success(YES);
    } else{
        NSError* error=[NSError errorWithDomain:@"Empty array" code:100 userInfo:nil];
        failure(error);
    }
}


#pragma mark - UI Handlers

- (void) didSelectAtRowFromTable:(NSIndexPath*) indexPath {
    // ...
}


#pragma mark - Others helpers

- (NSArray*) generateVMforCells
{
    NSInteger countLeftAlignmentCell  =  RAND_FROM_TO(1, 50);
    NSInteger countRightAlignmentCell =  RAND_FROM_TO(1, 50);
    NSInteger countBigNameCell        =  RAND_FROM_TO(1, 50);
    
    NSMutableArray* vmForCellsArray = [NSMutableArray new];
    
    for (int i = 0; i <= (countLeftAlignmentCell+countRightAlignmentCell+countBigNameCell); i++)
    {
        if (i % 2 == 0)
        {
            if (arc4random() % 2 == 0)
                [vmForCellsArray addObject:[[ViewModel_WorkerLeftAlignment_Cell alloc] initWithWorker:_modelWorker]];
            else
                [vmForCellsArray addObject:[[ViewModel_WorkerRightAlignment_Cell alloc] initWithWorker:_modelWorker]];
        } else {
            if (arc4random() % 2 == 0)
                [vmForCellsArray addObject:[[ViewModel_WorkerBigName_Cell alloc]initWithWorker:_modelWorker]];
        }
    }
    return vmForCellsArray;
}

@end
