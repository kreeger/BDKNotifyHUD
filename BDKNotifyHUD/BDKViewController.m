#import "BDKViewController.h"
#import "BDKNotifyHUD.h"

#import <QuartzCore/QuartzCore.h>

@interface BDKViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) BDKNotifyHUD *notify;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapRecognizer;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *notificationText;

- (void)viewDoubleTapped:(id)sender;

@end

@implementation BDKViewController

- (id)init {
    if ((self = [super init])) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self.view addGestureRecognizer:self.doubleTapRecognizer];
        self.notificationText = @"This is a checkmark!";
        self.imageName = @"Checkmark.png";
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
    [self.view addSubview:self.label];
    
    // Notification.
    [self displayNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Properties

- (UIImageView *)imageView {
    if (_imageView != nil) return _imageView;
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    _imageView.layer.opacity = 0.65f;
    return _imageView;
}

- (BDKNotifyHUD *)notify {
    if (_notify != nil) return _notify;
    _notify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:self.imageName] text:self.notificationText];
    _notify.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    return _notify;
}

- (UITapGestureRecognizer *)doubleTapRecognizer {
    if (_doubleTapRecognizer != nil) return _doubleTapRecognizer;
    _doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDoubleTapped:)];
    _doubleTapRecognizer.numberOfTapsRequired = 2;
    _doubleTapRecognizer.numberOfTouchesRequired = 1;
    return _doubleTapRecognizer;
}

- (UILabel *)label {
    if (_label != nil) return _label;
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.text = @"Double-tap me!";
    _label.font = [UIFont boldSystemFontOfSize:18];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
    _label.layer.cornerRadius = 10.0f;
    [_label sizeToFit];
    CGRect frame = _label.frame;
    frame.size.width = frame.size.width + 20.0f;
    frame.size.height = frame.size.height + 10.0f;
    frame.origin.x = (self.view.frame.size.width - frame.size.width) / 2;
    frame.origin.y = (self.view.center.y + 150);
    _label.frame = frame;
    return _label;
}

#pragma mark - Actions

- (void)viewDoubleTapped:(id)sender {
    NSLog(@"View double tapped.");
    if (self.label.superview) {
        [UIView animateWithDuration:0.5f animations:^{
            self.label.alpha = 0;
        } completion:^(BOOL finished) {
            [self.label removeFromSuperview];
        }];
    }
    [self switchImages];
    [self displayNotification];
}

- (void)switchImages {
    if ([self.imageName isEqualToString:@"Checkmark.png"]) {
        self.imageName = @"Star.png";
        self.notificationText = @"This is a star!";
    } else {
        self.imageName = @"Checkmark.png";
        self.notificationText = @"This is a checkmark!";
    }
    
    self.notify.image = [UIImage imageNamed:self.imageName];
    self.notify.text = self.notificationText;
}

- (void)displayNotification {
    if (self.notify.isAnimating) return;
    
    [self.view addSubview:self.notify];
    [self.notify presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
        [self.notify removeFromSuperview];
    }];
}


@end
