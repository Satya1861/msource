

#import <UIKit/UIKit.h>

@class SLCircularProgressView;

@protocol SLCircularProgressViewDelegate
@required
@optional
-(void)progressView:(SLCircularProgressView*)view updatedPercent:(float)percent;

@end

@interface SLCircularProgressView : UIControl  
{
	NSObject<SLCircularProgressViewDelegate>* __weak _delegate;
}
@property (weak) NSObject<SLCircularProgressViewDelegate>* delegate;
@property (strong) UIColor* trackColor;
@property (strong) UIColor* endGradientColor;
@property (strong) UIColor* progressColor;
@property (assign,nonatomic) float percentCompleted;
-(void)setPercent:(float)percent animated:(BOOL)animated;

@end