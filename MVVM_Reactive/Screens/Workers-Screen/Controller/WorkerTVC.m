//
//  WorkerTVC.m
//  MVVM_NonReactive
//
//  Created by Uber on 08/08/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "WorkerTVC.h"


// ViewModels
#import "ViewModel_Worker_Cell.h"

// Models
#import "WorkerShort.h"

// Cell
#import "WorkerCell.h"

// Another fraemworks
#import <ANHelperFunctions/ANHelperFunctions.h>

@interface WorkerTVC ()


@end

@implementation WorkerTVC

#pragma mark - Inits methods

- (instancetype)init
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"WorkerTVC"];
    
    if (self) {
        self.title = @"Apple`s Engineers";
        
        UIImage *logOutIcon   = [[UIImage imageNamed:@"logout"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (self.navigationItem){
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:logOutIcon
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:@selector(logoutAction)];
        }
    }
    return self;
}


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    [RACObserve(self.vmListOfWorkers_TableView, cellsArray) subscribeNext:^(NSArray* cellsArray) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.vmListOfWorkers_TableView countWorkers];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[_vmListOfWorkers_TableView cellViewModel:indexPath.row] isKindOfClass: [ViewModel_Worker_Cell class]]){
         WorkerCell* cell  = (WorkerCell*)[tableView dequeueReusableCellWithIdentifier:@"WorkerCell"];
         [self configureCell:cell atIndexPath:indexPath];
         return cell;
    }
  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.vmListOfWorkers_TableView didSelectAtRowFromTable:indexPath];
}

#pragma mark - UITableView helper methods

- (void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath
{
    ANDispatchBlockToBackgroundQueue(^{
        id vm  = [self.vmListOfWorkers_TableView cellViewModel:indexPath.row];
        if ([vm isKindOfClass: [ViewModel_Worker_Cell class]]){           
            [cell bindWithViewModel:vm];
        }
    });
}


#pragma mark - Actions

- (void)logoutAction {
    [self.vmListOfWorkers_TableView logoutBtnClicked];
}

#pragma mark - Others

// Setters
- (void) setVmListOfWorkers_TableView:(ViewModel_ListOfWorkers_TableView *)vmListOfWorkers_TableView
{
    @weakify(self);
    [[vmListOfWorkers_TableView getSignalUpdateWorkerList] subscribeNext:^(NSNumber* successOperation) {
        @strongify(self);
        ANDispatchBlockToMainQueue(^{
            [self.tableView reloadData];
        });
    } error:^(NSError *error) {
        NSLog(@"setControllerVM = %@",error);
    }];
    _vmListOfWorkers_TableView = vmListOfWorkers_TableView;
}

@end
