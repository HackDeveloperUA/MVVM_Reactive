//
//  ViewModel_ListOfPsychedelicWorkers_TableView.h
//  MVVM_NonReactive
//
//  Created by Uber on 14/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>

// Reactive
#import <ReactiveCocoa/ReactiveCocoa.h>


@class WorkerFull;
@class ViewModel_BasedWorker_Cell;

@interface ViewModel_ListOfPsychedelicWorkers_TableView : NSObject

@property (nonatomic, strong) NSMutableArray* vmForCellsArray;  // Here store ViewModels
@property (nonatomic, strong) WorkerFull*     modelWorker;      // Here story Model


#pragma mark - Init methods
- (instancetype)initWithWorker:(WorkerFull*) workerModel;


#pragma mark - Methods for TableView work
- (ViewModel_BasedWorker_Cell*) cellViewModel:(NSInteger) index;
- (NSInteger) countWorkers;


#pragma mark - Reactive API Method
- (RACSignal*) getSignal_generateVMforCells;


#pragma mark - None Reactive API Method
- (void) generateVMforCells:(void(^)(BOOL successOperation)) success
                  onFailure:(void(^)(NSError* errorBlock)) failure;


#pragma mark - UI Handlers
- (void) didSelectAtRowFromTable:(NSIndexPath*) indexPath;

@end







