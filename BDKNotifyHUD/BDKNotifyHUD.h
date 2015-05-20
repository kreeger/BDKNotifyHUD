#import <UIKit/UIKit.h>

#define kBDKNotifyHUDDefaultWidth 130.0f
#define kBDKNotifyHUDDefaultHeight 100.0f

@interface BDKNotifyHUD : UIView

@property (nonatomic) CGFloat destinationOpacity;
@property (nonatomic) CGFloat currentOpacity;
@property (nonatomic) UIView *iconView;
@property (nonatomic) CGFloat roundness;
@property (nonatomic) BOOL bordered;
@property (nonatomic) BOOL isAnimating;

@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSAttributedString *attributedText;

+ (id)notifyHUDWithView:(UIView *)view text:(NSString *)text;
+ (id)notifyHUDWithImage:(UIImage *)image text:(NSString *)text;

+ (id)notifyHUDWithView:(UIView *)view attributedText:(NSAttributedString *)attributedText;
+ (id)notifyHUDWithImage:(UIImage *)image attributedText:(NSAttributedString *)attributedText;

- (id)initWithView:(UIView *)view text:(NSString *)text;
- (id)initWithImage:(UIImage *)image text:(NSString *)text;

- (id)initWithImage:(UIImage *)image attributedText:(NSAttributedString *)attributedText;
- (id)initWithView:(UIView *)view attributedText:(NSAttributedString *)attributedText;

- (void)setImage:(UIImage *)image;
- (void)presentWithDuration:(CGFloat)duration speed:(CGFloat)speed inView:(UIView *)view completion:(void (^)(void))completion;

@end
