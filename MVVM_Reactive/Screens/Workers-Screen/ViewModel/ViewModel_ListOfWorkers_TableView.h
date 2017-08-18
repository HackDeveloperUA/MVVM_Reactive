//
//  WorkerViewModel.h
//  MVVM_NonReactive
//
//  Created by Uber on 08/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>

// Cell VM
#import "ViewModel_Worker_Cell.h"

// Model
#import "WorkerShort.h"

// Router
#import "Router.h"

// ReactiveCocoa
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewModel_ListOfWorkers_TableView : NSObject

@property (nonatomic, strong) NSMutableArray* cellsArray; // Here store ViewModels
@property (nonatomic, strong) NSMutableArray* modelArray; // Here story Model


#pragma mark - Methods for TableView work

- (ViewModel_Worker_Cell*) cellViewModel:(NSInteger) index;
- (NSInteger) countWorkers;

#pragma mark  - UI Handlers

- (void) didSelectAtRowFromTable:(NSIndexPath*) indexPath;
- (void) logoutBtnClicked;


#pragma mark - None Reactive API Method

- (void) updateWorkerList:(void(^)(BOOL successOperation)) success
                onFailure:(void(^)(NSError* errorBlock,  NSObject* errObj)) failure;


#pragma mark - Reactive API Method

- (RACSignal*) getSignalUpdateWorkerList;

@end
