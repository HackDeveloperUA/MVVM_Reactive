//
//  PsychedelicDetailTVC.m
//  MVVM_NonReactive
//
//  Created by Uber on 14/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "HDPsychedelicDetailTVC.h"


// ViewModel - Controller
#import "ViewModel_ListOfPsychedelicWorkers_TableView.h"

// ViewModel - Cells
#import "ViewModel_BasedWorker_Cell.h"
#import "ViewModel_WorkerLeftAlignment_Cell.h"
#import "ViewModel_WorkerRightAlignment_Cell.h"
#import "ViewModel_WorkerBigName_Cell.h"

// View - Cells
#import "WorkerLeftAlignment_Cell.h"
#import "WorkerRightAlignment_Cell.h"
#import "WorkerBigName_Cell.h"


// Model
#import "WorkerFull.h"

// Router
#import "Router.h"

// Another fraemworks
#import <ANHelperFunctions/ANHelperFunctions.h>

@interface HDPsychedelicDetailTVC ()

@end

@implementation HDPsychedelicDetailTVC

#pragma mark - Init methods

- (instancetype)initWithVM:(ViewModel_ListOfPsychedelicWorkers_TableView*) vm
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"HDPsychedelicDetailTVC"];
    
    if (self) {
        self.vmListOfPsychedelicWorkers_TableView = vm;
        [[RACObserve(self.vmListOfPsychedelicWorkers_TableView.modelWorker, firstName) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            self.title = x;
        }];
        
    }
    return self;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.vmListOfPsychedelicWorkers_TableView countWorkers];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id cell;
    
    if ([[_vmListOfPsychedelicWorkers_TableView cellViewModel:indexPath.row]   isKindOfClass: [ViewModel_WorkerLeftAlignment_Cell class]]){
        
        cell = (WorkerLeftAlignment_Cell*)[tableView dequeueReusableCellWithIdentifier:@"WorkerLeftAlignment_Cell"];
    }
    
    if ([[_vmListOfPsychedelicWorkers_TableView cellViewModel:indexPath.row]   isKindOfClass: [ViewModel_WorkerRightAlignment_Cell class]]){
        
        cell = (WorkerRightAlignment_Cell*)[tableView dequeueReusableCellWithIdentifier:@"WorkerRightAlignment_Cell"];
    }
    
    if ([[_vmListOfPsychedelicWorkers_TableView cellViewModel:indexPath.row]   isKindOfClass: [ViewModel_WorkerBigName_Cell class]]){
        
        cell = (WorkerBigName_Cell*)[tableView dequeueReusableCellWithIdentifier:@"WorkerBigName_Cell"];
    }

    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:cell atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.vmListOfPsychedelicWorkers_TableView didSelectAtRowFromTable:indexPath];
}


#pragma mark - UITableView helper methods

- (void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath
{
    ANDispatchBlockToBackgroundQueue(^{
       
        id vm  = [self.vmListOfPsychedelicWorkers_TableView cellViewModel:indexPath.row];
      
        if ([vm isKindOfClass: [ViewModel_WorkerLeftAlignment_Cell class]]){
            [cell bindWithViewModel:vm];
        }
        
        if ([vm isKindOfClass: [ViewModel_WorkerRightAlignment_Cell class]]){
            [cell bindWithViewModel:vm];
        }
        
        if ([vm isKindOfClass: [ViewModel_WorkerBigName_Cell class]]){
            [cell bindWithViewModel:vm];
        }
    });
}

#pragma mark - Others


- (void) setVmListOfPsychedelicWorkers_TableView:(ViewModel_ListOfPsychedelicWorkers_TableView *)vmListOfPsychedelicWorkers_TableView {
    
    _vmListOfPsychedelicWorkers_TableView = vmListOfPsychedelicWorkers_TableView;
    
    @weakify(self);
    RACScheduler* mainThreadScheduler = [RACScheduler mainThreadScheduler];
   
    [[[vmListOfPsychedelicWorkers_TableView getSignal_generateVMforCells] deliverOn:mainThreadScheduler]
     subscribeNext:^(NSNumber* successOperation) {
       
         @strongify(self);
         if ([successOperation boolValue]){
             [self.tableView reloadData];
         }
        
    }error:^(NSError *error) {
        NSLog(@"getSignal_generateVMforCells error = %@",error);

    } completed:^{
        NSLog(@"getSignal_generateVMforCells completed");
    }];
}

@end
