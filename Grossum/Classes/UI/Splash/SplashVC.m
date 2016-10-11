//
//  SplashVC.m
//  Grossum
//
//  Created by Alexandr Chernyy on 10/10/16.
//  Copyright © 2016 Alexandr Chernyy. All rights reserved.
//

#import "SplashVC.h"
#import "Constants.h"

@interface SplashVC ()
@property (weak, nonatomic) IBOutlet UIImageView *splashLoadingImage;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) NSMutableArray *imgQueue;
@property (nonatomic, strong) NSTimer * loadingTimer;
@property (nonatomic, assign) int loadingStep;

@end

@implementation SplashVC
@synthesize imgQueue;
@synthesize loadingTimer;
@synthesize loadingStep;

- (void)viewDidLoad {
    loadingStep = 0;
    [super viewDidLoad];
    [self loadImagesFromMemory];
    self.loadingLabel.text = TEXT_LOADING;
    loadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(loadStep) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void) loadImagesFromMemory {
    NSArray *PhotoArray = [[NSBundle mainBundle] pathsForResourcesOfType:iconsFileExtentions inDirectory:iconsFolderName];
    imgQueue = [[NSMutableArray alloc] initWithCapacity:PhotoArray.count];
    for (NSString* path in PhotoArray) {
        [imgQueue addObject:[UIImage imageWithContentsOfFile:path]];
    }
}

-(void) showMainScreen {
    [self performSegueWithIdentifier:SEGUE_NAME_MAIN sender:self];
}

-(void) loadStep {
    if(loadingStep >= imgQueue.count) {
        [loadingTimer invalidate];
        loadingTimer = nil;
        [self showMainScreen];
    } else {
        self.splashLoadingImage.image = (UIImage *)[imgQueue objectAtIndex:loadingStep];
        loadingStep++;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
