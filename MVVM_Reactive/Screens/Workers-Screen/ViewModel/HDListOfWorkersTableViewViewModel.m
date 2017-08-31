//
//  WorkerViewModel.m
//  MVVM_NonReactive
//
//  Created by Uber on 08/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "HDListOfWorkersTableViewViewModel.h"

// Model
#import "WorkerShort.h"

// Router
#import "Router.h"

// Server API
#import "ServerManager.h"

@implementation HDListOfWorkersTableViewViewModel


#pragma mark - Init methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellsArray = [NSMutableArray array];
        
    }
    return self;
}


#pragma mark - Methods for TableView work

- (NSInteger) countWorkers{
    return self.cellsArray.count;
}


- (ViewModel_Worker_Cell*) cellViewModel:(NSInteger) index {
   
    if (index > self.cellsArray.count){
        return nil;
    }
    return self.cellsArray[index];
}


#pragma mark  - UI Handlers

- (void) didSelectAtRowFromTable:(NSIndexPath*) indexPath {
    
    ViewModel_Worker_Cell* cellVM = [self cellViewModel:indexPath.row];
    [[Router sharedRouter] openDetailVCwithLinkOnFullCV: cellVM.model.linkOnFullModel];
}

- (void) logoutBtnClicked {
    
    [[Router sharedRouter] setIsLoginInUserDefaults:NO];
    [[Router sharedRouter] openLoginVC];
}

#pragma mark - Reactive API Method
   

- (RACSignal*) getSignalUpdateWorkerList
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [self.cellsArray removeAllObjects];
        
        [[[ServerManager sharedManager] getListAllWorkers] subscribeNext:^(NSArray *arrayWorkers) {
            
            self.modelArray = [NSMutableArray arrayWithArray:arrayWorkers];
            for (WorkerShort* worker in arrayWorkers) {
                [self.cellsArray addObject: [[ViewModel_Worker_Cell alloc] initWithWorker: worker]];
            }
            [subscriber sendNext:@(YES)];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            
        }];
        
        return nil;
    }];
}


#pragma mark - None Reactive API Method

- (void) updateWorkerList:(void(^)(BOOL successOperation)) success
                onFailure:(void(^)(NSError* errorBlock,  NSObject* errObj)) failure {
    
    [self.cellsArray removeAllObjects];
    
    [[ServerManager sharedManager] getListAllWorkers:^(NSArray *arrayWorkers) {
        self.modelArray = [NSMutableArray arrayWithArray:arrayWorkers];
        
        for (WorkerShort* worker in arrayWorkers) {
            [self.cellsArray addObject: [[ViewModel_Worker_Cell alloc] initWithWorker: worker]];
        }
        
        success(YES);
        
    } onFailure:^(NSError *errorBlock, NSInteger statusCode) {
        
        failure(errorBlock, [NSObject new]);
    }];
}

@end

































