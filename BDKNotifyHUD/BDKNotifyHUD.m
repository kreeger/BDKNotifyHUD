#import "BDKNotifyHUD.h"
#import <QuartzCore/QuartzCore.h>

#define kBDKNotifyHUDDefaultRoundness    10.0f
#define kBDKNotifyHUDDefaultOpacity      0.75f
#define kBDKNotifyHUDDefaultPadding      10.0f
#define kBDKNotifyHUDDefaultInnerPadding 6.0f

@implementation NSObject (PerformBlockAfterDelay)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay {
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:) withObject:block afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}

@end

@interface BDKNotifyHUD ()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textLabel;

- (void)recalculateHeight;
- (void)adjustTextLabel:(UILabel *)label;
- (void)fadeAfter:(CGFloat)duration speed:(CGFloat)speed completion:(void (^)(void))completion;

@end

@implementation BDKNotifyHUD

#pragma mark - Lifecycle

+ (id)notifyHUDWithImage:(UIImage *)image text:(NSString *)text {
    return [[self alloc] initWithImage:image text:text];
}

+ (CGRect)defaultFrame {
    return CGRectMake(0, 0, kBDKNotifyHUDDefaultWidth, kBDKNotifyHUDDefaultHeight);
}

- (id)initWithImage:(UIImage *)image text:(NSString *)text {
    if ((self = [self initWithFrame:[self.class defaultFrame]])) {
        self.image = image;
        self.text = text;
        self.roundness = kBDKNotifyHUDDefaultRoundness;
        self.borderColor = [UIColor clearColor];
        self.destinationOpacity = kBDKNotifyHUDDefaultOpacity;
        self.currentOpacity = 0.0f;
    }
    return self;
}

- (void)presentWithDuration:(CGFloat)duration speed:(CGFloat)speed inView:(UIView *)view completion:(void (^)(void))completion {
    NSLog(@"Animating with speed %.0f.", speed);
    
    [UIView animateWithDuration:speed animations:^{
        [self setCurrentOpacity:self.destinationOpacity];
    } completion:^(BOOL finished) {
        NSLog(@"Notification view appeared.");
        [self fadeAfter:duration speed:speed completion:completion];
    }];
}

- (void)fadeAfter:(CGFloat)duration speed:(CGFloat)speed completion:(void (^)(void))completion {
    [self performBlock:^{
        [UIView animateWithDuration:speed animations:^{
            [self setCurrentOpacity:0.0];
        } completion:^(BOOL finished) {
            NSLog(@"Notification view disappeared.");
            if (completion != nil) completion();
        }];
    } afterDelay:duration];
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
    if (_textLabel != nil) self.textLabel.text = text;
    [self adjustTextLabel:self.textLabel];
    NSLog(@"Text label max Y now %.0f.", CGRectGetMaxY(self.textLabel.frame));
    _text = text;
}

- (void)setImage:(UIImage *)image {
    if (_imageView != nil) self.imageView.image = image;
    _image = image;
}

- (void)setCurrentOpacity:(CGFloat)currentOpacity {
    if (_backgroundView != nil) self.backgroundView.alpha = currentOpacity;
    if (_imageView != nil) self.imageView.alpha = currentOpacity;
    if (_textLabel != nil) self.textLabel.alpha = currentOpacity;
    NSLog(@"Setting alpha to %.1f.", currentOpacity);
    _currentOpacity = currentOpacity;
}

#pragma mark - Getters

- (UIView *)backgroundView {
    if (_backgroundView != nil) return _backgroundView;
    
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.layer.cornerRadius = self.roundness;
    _backgroundView.layer.borderWidth = 1.0f;
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.layer.borderColor = [self.borderColor CGColor];
    
    return _backgroundView;
}

- (UIImageView *)imageView {
    if (_imageView != nil) return _imageView;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.contentMode = UIViewContentModeCenter;
    if (self.image != nil) { 
        _imageView.image = self.image;
        CGRect frame = _imageView.frame;
        frame.size = self.image.size;
        frame.origin = CGPointMake((self.backgroundView.frame.size.width - frame.size.width) / 2, kBDKNotifyHUDDefaultPadding);
        _imageView.frame = frame;
    }
    
    return _imageView;
}

- (UILabel *)textLabel {
    if (_textLabel != nil) return _textLabel;
    
    CGRect frame = CGRectMake(0, floorf(CGRectGetMaxY(self.imageView.frame) + kBDKNotifyHUDDefaultInnerPadding),
                              floorf(self.backgroundView.frame.size.width),
                              floorf(self.backgroundView.frame.size.height / 2.0f));
    _textLabel = [[UILabel alloc] initWithFrame:frame];
    _textLabel.font = [UIFont boldSystemFontOfSize:18];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 0;
    if (self.text != nil) _textLabel.text = self.text;
    [self adjustTextLabel:_textLabel];
    
    return _textLabel;
}

#pragma mark - UIView

- (void)layoutSubviews {
    if (self.backgroundView.superview) [self.backgroundView removeFromSuperview];
    if (self.imageView.superview) [self.imageView removeFromSuperview];
    if (self.textLabel.superview) [self.textLabel removeFromSuperview];
    self.backgroundView = nil;
    self.imageView = nil;
    self.textLabel = nil;
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.imageView];
    [self addSubview:self.textLabel];
    [self recalculateHeight];
}

- (void)adjustTextLabel:(UILabel *)label {
    [label sizeToFit];
    CGRect frame = _textLabel.frame;
    frame.origin.x = floorf((self.backgroundView.frame.size.width - _textLabel.frame.size.width) / 2);
    _textLabel.frame = frame;
}

- (void)recalculateHeight {
    CGRect frame = self.backgroundView.frame;
    frame.size.height = CGRectGetMaxY(self.textLabel.frame) + kBDKNotifyHUDDefaultPadding;
    self.backgroundView.frame = frame;
}

@end
