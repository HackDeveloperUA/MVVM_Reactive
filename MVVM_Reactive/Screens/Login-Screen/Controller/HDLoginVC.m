//
//  LoginVC.m
//  MVVM_NonReactive
//
//  Created by Uber on 27/07/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "HDLoginVC.h"
#import "Router.h"

#import "SMErrorAuthentication.h"

@interface HDLoginVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *grayView;

@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UITextField *passField;

@property (weak, nonatomic) IBOutlet UIButton *fogotPassBtn;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIButton *createAccountBtn;

@end

@implementation LoginVC


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    // 1. Register tap to hide the keyboard
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    [self.view addGestureRecognizer:tapGesture];
    
    
    @weakify(self);
    [[RACSignal combineLatest:@[self.loginField.rac_textSignal,
                                self.passField.rac_textSignal]]
     subscribeNext:^(RACTuple *tuple) {
         RACTupleUnpack(NSString* login, NSString* password) = tuple;
         
         @strongify(self);
         if(login.length > 3 && password.length > 3){
             self.signInBtn.enabled = YES;
             self.signInBtn.backgroundColor = [UIColor blueColor];
         }else {
             self.signInBtn.enabled = NO;
             self.signInBtn.backgroundColor = [UIColor redColor];
         }
     }];
}


- (void) viewWillAppear:(BOOL)animated
{  [super viewWillAppear:animated];     [self addObservers];     }

- (void) viewWillDisappear:(BOOL)animated
{  [super viewWillDisappear:animated];  [self removeObservers];  }


#pragma mark - Action

- (IBAction)signInAction:(UIButton *)sender
{
    // "admin"    : "12345",
    [self animatedHUD:YES];

   RACSignal* signal = [self.vmAccountsData signInBtnClicked:@"admin" andPass:@"12345"];
    
   [[[signal subscribeOn:[RACScheduler scheduler]] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {

   } error:^(id error) {
       
       [self animatedHUD:NO];

       if ([error isKindOfClass:[SMErrorAuthentication class]])
       {
           UIAlertController* alertVC = [Utilites getAlertVCError: error];
           [self presentViewController:alertVC animated:YES completion:nil];
       }
   } completed:^{
       
       [self animatedHUD:NO];
       [[Router sharedRouter] setIsLoginInUserDefaults: YES];
       [[Router sharedRouter] openWorkersTVC];
   }];
}


#pragma mark - Others

- (void) animatedHUD:(BOOL) animated {
    
    ANDispatchBlockToMainQueue(^{
        if (animated)
            [self.HUD show:animated];
        else
            [self.HUD hide:animated];
        
        self.view.userInteractionEnabled = !animated;
    });
}

- (void) setupUI {
    // Arounds buttons
    [Utilites aroundView:self.fogotPassBtn     withCorner:45];
    [Utilites aroundView:self.signInBtn        withCorner:45];
    [Utilites aroundView:self.createAccountBtn withCorner:45];
    [Utilites aroundView:self.grayView         withCorner:45];
    
    [Utilites addShadowForView:self.grayView  withColor:[UIColor blackColor] andOffset:CGSizeMake(0.0f, 2.0f) andRaius:2.0f];
    [Utilites addShadowForView:self.signInBtn withColor:[UIColor blackColor] andOffset:CGSizeMake(0.0f, 2.0f) andRaius:2.0f];
    [Utilites addShadowForView:self.createAccountBtn withColor:[UIColor blackColor] andOffset:CGSizeMake(0.0f, 2.0f) andRaius:2.0f];
    
    self.HUD    = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
}


#pragma mark - Keybords methods

- (void) addObservers {
    // Notification that appears when you open the keyboard
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification*  note) {
        [self keyboardWillShow:note];
    }];
    // Notification that appears when you close the keyboard
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification*  note) {
        [self keyboardWillHide:note];
    }];
}

- (void) keyboardWillShow:(NSNotification*) notification {
    // Get Dictionary
    NSDictionary* userInfo = notification.userInfo;
    if (userInfo)
    {
        // Pull out frame which describes the coordinates of the keyboard
        CGRect frame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        // Create an inset at the height of the keyboard
        UIEdgeInsets contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(frame), 0);
        // Применяем отступ - Apply the inset
        self.scrollView.contentInset = contentInset;
    }
}

- (void) keyboardWillHide:(NSNotification*) notification{
    // Cancel inset
    self.scrollView.contentInset = UIEdgeInsetsZero;
}

- (void) removeObservers{
    // Unsubscribe from notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) didTapView:(UITapGestureRecognizer*) gesture{
    [self.view endEditing:YES];
}

- (instancetype)init{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    
    if (self) {
        
    }
    return self;
}


@end
