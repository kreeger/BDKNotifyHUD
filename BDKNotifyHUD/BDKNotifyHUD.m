#import "BDKNotifyHUD.h"

#import <QuartzCore/QuartzCore.h>

#define kBDKNotifyHUDDefaultRoundness    10.0f
#define kBDKNotifyHUDDefaultOpacity      0.75f
#define kBDKNotifyHUDDefaultPadding      10.0f
#define kBDKNotifyHUDDefaultInnerPadding 6.0f

@interface BDKNotifyHUD ()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UILabel *textLabel;

- (void)setupView;
- (void)recalculateHeight;
- (void)adjustTextLabel:(UILabel *)label;
- (UIView *)configureViewForCentering:(UIView *)view;
- (void)fadeAfter:(CGFloat)duration speed:(CGFloat)speed completion:(void (^)(void))completion;

@end

@implementation BDKNotifyHUD

#pragma mark - Lifecycle

+ (id)notifyHUDWithView:(UIView *)view text:(NSString *)text {
    return [[self alloc] initWithView:view text:text];
}

+ (id)notifyHUDWithImage:(UIImage *)image text:(NSString *)text {
    return [[self alloc] initWithImage:image text:text];
}

+ (CGRect)defaultFrame {
    return CGRectMake(0, 0, kBDKNotifyHUDDefaultWidth, kBDKNotifyHUDDefaultHeight);
}

- (id)initWithView:(UIView *)view text:(NSString *)text {
    if ((self = [self initWithFrame:[self.class defaultFrame]])) {
        self.iconView = [self configureViewForCentering:view];
        self.text = text;
        [self setupView];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image text:(NSString *)text {
    if ((self = [self initWithFrame:[self.class defaultFrame]])) {
        [self setImage:image];
        self.text = text;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.roundness = kBDKNotifyHUDDefaultRoundness;
    self.borderColor = [UIColor clearColor];
    self.destinationOpacity = kBDKNotifyHUDDefaultOpacity;
    self.currentOpacity = 0.0f;
    [self addSubview:self.backgroundView];
    [self addSubview:self.iconView];
    [self addSubview:self.textLabel];
    [self recalculateHeight];
}

- (void)presentWithDuration:(CGFloat)duration speed:(CGFloat)speed inView:(UIView *)view completion:(void (^)(void))completion {
    self.isAnimating = YES;
    [UIView animateWithDuration:speed animations:^{
        [self setCurrentOpacity:self.destinationOpacity];
    } completion:^(BOOL finished) {
        if (finished) [self fadeAfter:duration speed:speed completion:completion];
    }];
}

- (void)fadeAfter:(CGFloat)duration speed:(CGFloat)speed completion:(void (^)(void))completion {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:speed animations:^{
            [self setCurrentOpacity:0.0];
        } completion:^(BOOL finished) {
            if (finished) {
                self.isAnimating = NO;
                if (completion != nil) completion();
            }
        }];
    });
}

#pragma mark - Setters

- (void)setRoundness:(CGFloat)roundness {
    if (_backgroundView != nil) self.backgroundView.layer.cornerRadius = roundness;
    _roundness = roundness;
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (_backgroundView != nil) self.backgroundView.layer.borderColor = [borderColor CGColor];
    _borderColor = borderColor;
}

- (void)setText:(NSString *)text {
    if (_textLabel != nil) {
        self.textLabel.text = text;
        [self adjustTextLabel:self.textLabel];
    }
    _text = text;
}

- (void)setImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = image;
    CGRect frame = imageView.frame;
    frame.size = image.size;
    imageView.frame = frame;
    imageView = (UIImageView *)[self configureViewForCentering:imageView];
    _iconView = imageView;
}

- (void)setCurrentOpacity:(CGFloat)currentOpacity {
    self.iconView.alpha = currentOpacity > 0 ? 1.0f : 0.0f;
    self.textLabel.alpha = currentOpacity > 0 ? 1.0f : 0.0f;
    self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:currentOpacity];
    _currentOpacity = currentOpacity;
}

#pragma mark - Getters

- (UIView *)backgroundView {
    if (_backgroundView != nil) return _backgroundView;
    
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.layer.cornerRadius = self.roundness;
    _backgroundView.layer.borderWidth = 1.0f;
    _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
    _backgroundView.layer.borderColor = [self.borderColor CGColor];
    
    return _backgroundView;
}

- (UILabel *)textLabel {
    if (_textLabel != nil) return _textLabel;
    
    CGRect frame = CGRectMake(0, floorf(CGRectGetMaxY(self.iconView.frame) + kBDKNotifyHUDDefaultInnerPadding),
                              floorf(self.backgroundView.frame.size.width),
                              floorf(self.backgroundView.frame.size.height / 2.0f));
    _textLabel = [[UILabel alloc] initWithFrame:frame];
    _textLabel.font = [UIFont boldSystemFontOfSize:18];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.alpha = 0.0f;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 0;
    if (self.text != nil) _textLabel.text = self.text;
    [self adjustTextLabel:_textLabel];
    [self recalculateHeight];
    
    return _textLabel;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [self recalculateHeight];
}

- (UIView *)configureViewForCentering:(UIView *)view {
    view.backgroundColor = [UIColor clearColor];
    view.contentMode = UIViewContentModeCenter;
    CGRect frame = view.frame;
    frame.origin = CGPointMake((self.backgroundView.frame.size.width - frame.size.width) / 2, kBDKNotifyHUDDefaultPadding);
    view.frame = frame;
    view.alpha = 0.0f;
    return view;
}

- (void)adjustTextLabel:(UILabel *)label {
    CGRect frame = _textLabel.frame;
    frame.size.width = self.backgroundView.frame.size.width;
    _textLabel.frame = frame;
    [label sizeToFit];
    frame = _textLabel.frame;
    frame.origin.x = floorf((self.backgroundView.frame.size.width - _textLabel.frame.size.width) / 2);
    _textLabel.frame = frame;
}

- (void)recalculateHeight {
    CGRect frame = self.backgroundView.frame;
    frame.size.height = CGRectGetMaxY(self.textLabel.frame) + kBDKNotifyHUDDefaultPadding;
    self.backgroundView.frame = frame;
}

@end
