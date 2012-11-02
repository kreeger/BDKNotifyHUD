#import "BDKViewController.h"
#import "BDKNotifyHUD.h"

#import <QuartzCore/QuartzCore.h>

@interface BDKViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) BDKNotifyHUD *notify;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapRecognizer;

- (void)viewTapped:(id)sender;

@end

@implementation BDKViewController

- (id)init {
    if ((self = [super init])) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self.view addGestureRecognizer:self.doubleTapRecognizer];
        [self.view addGestureRecognizer:self.tapRecognizer];
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    // Background.
    [self.view addSubview:self.imageView];
    
    // Notification.
    [self.view addSubview:self.notify];
    self.notify.currentOpacity = 0.5f;
//    [self.notify presentWithDuration:5.0f speed:2.0f inView:self.view completion:^{
//        [self.notify removeFromSuperview];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Properties

- (UIImageView *)imageView {
    if (_imageView != nil) return _imageView;
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    _imageView.layer.opacity = 0.5f;
    return _imageView;
}

- (BDKNotifyHUD *)notify {
    if (_notify != nil) return _notify;
    _notify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Checkmark.png"] text:@"This is a notification!"];
    _notify.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    return _notify;
}

- (UITapGestureRecognizer *)tapRecognizer {
    if (_tapRecognizer != nil) return _tapRecognizer;
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    _tapRecognizer.numberOfTapsRequired = 1;
    _tapRecognizer.numberOfTouchesRequired = 1;
    [_tapRecognizer requireGestureRecognizerToFail:self.doubleTapRecognizer];
    return _tapRecognizer;
}

- (UITapGestureRecognizer *)doubleTapRecognizer {
    if (_doubleTapRecognizer != nil) return _doubleTapRecognizer;
    _doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDoubleTapped:)];
    _doubleTapRecognizer.numberOfTapsRequired = 2;
    _doubleTapRecognizer.numberOfTouchesRequired = 1;
    return _doubleTapRecognizer;
}

#pragma mark - Actions

- (void)viewTapped:(id)sender {
    NSLog(@"View single tapped.");
    self.notify.image = [UIImage imageNamed:@"Star.png"];
    self.notify.text = @"Favorited!";
}

- (void)viewDoubleTapped:(id)sender {
    NSLog(@"View double tapped.");
}

@end
