

#import "SLCircularProgressView.h"
#define PI 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679
#define START_OFFSET 110
#define CENTER_INSET 20
#define kGoalPercent @"GoalPercent"

static inline float radians(double degrees) { return degrees * PI / 180; }

#pragma mark -
#pragma mark Private Interface
@interface SLCircularProgressView (){
  NSTimer* _currentTimer;
  int _percent;
}
@end

#pragma mark -
@implementation SLCircularProgressView

#pragma mark Constructors
-(void)initializeDefaults{
  self.trackColor = [UIColor colorWithRed:35.0f/255.0f green:35.0f/255.0f blue:35.0f/255.0f alpha:1.0];
    self.progressColor = [UIColor colorWithRed:245.0f/255.0f green:0.0f/255.0f blue:8.0f/255.0f alpha:1.0];
  self.endGradientColor = [UIColor colorWithRed:245.0f/255.0f green:0.0f/255.0f blue:8.0f/255.0f alpha:1.0];
}

- (id) initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self == nil)
    return nil;
  [self initializeDefaults];
   
  return self;
}

-(void)awakeFromNib{
  [self initializeDefaults];
}


#pragma mark -
#pragma mark Accessors
@synthesize delegate = _delegate;
@synthesize percentCompleted = _percentCompleted;
@synthesize trackColor = _trackColor;
@synthesize progressColor = _progressColor;
@synthesize endGradientColor = _endGradientColor;

-(void)setPercentCompleted:(float)percent{
  [self setPercent:percent animated:false];
}

#pragma mark - Private Methods
- (void) componentsOfColor:(UIColor*)color red:(float*)red green:(float*)green blue:(float*)blue alpha:(float*)alpha
{
  // Check the component count of the color space assocated with the CGColor (pattern and index colors are unsupported)
	int componentCount = CGColorGetNumberOfComponents(color.CGColor);
  if (componentCount < 2)
    return;
  
  // Pull the color components out of the CGColor
  // NOTE: Assumes that the color space is a grayscale color space or an RGB color space
  // (which seems to always be true in a typical UIColor)
	const float* components = CGColorGetComponents(color.CGColor);
	if (red != NULL)
    *red = componentCount == 4 ? components[0] : components[0];
	if (green != NULL)
    *green = componentCount == 4 ? components[1] : components[0];
	if (blue != NULL)
    *blue = componentCount == 4 ? components[2] : components[0];
	if (alpha != NULL)
    *alpha = componentCount == 4 ? components[3] : components[1];
}

-(void)animateWithTimer:(NSTimer*)timer{
  int goalPercent = [[timer.userInfo objectForKey:kGoalPercent] intValue];

  if(_percent < goalPercent){
    _percent++;
  }
  else if(_percent > goalPercent){
    _percent--;
  }
  else{
    _percent = goalPercent;
    [_currentTimer invalidate];
    _currentTimer= nil;
  }
  
  if([_delegate respondsToSelector:@selector(progressView:updatedPercent:)]){
    [_delegate progressView:self updatedPercent:_percent/100.0f];
  }
  [self setNeedsDisplay];
}


#pragma mark - Public Methods
-(void)setPercent:(float)percent animated:(BOOL)animated{
  //Invalidate any timer
  [_currentTimer invalidate];
  int newPercent = percent*100;
  
  //if we are not animating, just update the progress and return
  if(!animated){
    _percent = newPercent;
    //Update delegate if possible
    if([_delegate respondsToSelector:@selector(progressView:updatedPercent:)]){
      [_delegate progressView:self updatedPercent:_percent/100.0f];
    }
    [self setNeedsDisplay];
    return;
  }
  
  //Create new animation Timer
  _currentTimer =[NSTimer scheduledTimerWithTimeInterval:.05
                                                  target:self
                                                selector:@selector(animateWithTimer:)
                                                userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:newPercent] forKey:kGoalPercent]
                                                 repeats:true];
  
}

#pragma mark - UIView Overrides
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  
  
  int value = _percent * 360/100;
  
  // need some values to draw pie charts
  double start = 0 + START_OFFSET;
  double finish = value + START_OFFSET;
  
  if(start == finish){
    start = 360;
    finish = 0;
  }
  CGRect parentViewBounds = self.bounds;
  CGFloat x = CGRectGetWidth(parentViewBounds)*0.5;
  CGFloat y = CGRectGetHeight(parentViewBounds)*0.5;
  
  //Create colors and locations
  CGFloat locations [] = {
    0.0, 0.9, 1.0
  };
    
    
    CGFloat gradientColor [12];
    
        [self componentsOfColor:_progressColor red:&(gradientColor[0]) green:&(gradientColor[1]) blue:&(gradientColor[2]) alpha:&(gradientColor[3])];
        [self componentsOfColor:_progressColor red:&(gradientColor[4]) green:&(gradientColor[5]) blue:&(gradientColor[6]) alpha:&(gradientColor[7])];
        [self componentsOfColor:_progressColor red:&(gradientColor[8]) green:&(gradientColor[9]) blue:&(gradientColor[10]) alpha:&(gradientColor[11])];
 
 
  
  // Get the graphics context and clear it
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextClearRect(ctx, rect);
  
  // define stroke color
  CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1.0);
  
  // define line width
  CGContextSetLineWidth(ctx, 4.0);
  
  //Create fill gradient
  CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
  CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, gradientColor, locations, 3);
  CGColorSpaceRelease(baseSpace), baseSpace = NULL;
  
  CGContextSaveGState(ctx);
  CGContextAddEllipseInRect(ctx, CGRectInset(rect, 0, 0));
  CGContextClip(ctx);
  
  CGPoint centerpoint = CGPointMake(rect.origin.x + (rect.size.width / 2), rect.origin.y + (rect.size.height / 2));
  CGContextDrawRadialGradient(ctx, gradient, centerpoint, 0, centerpoint, rect.size.height*.5, 0);
  CGGradientRelease(gradient), gradient = NULL;
  CGContextRestoreGState(ctx);
  
  // draw pie chart
  CGContextSetFillColorWithColor( ctx, _trackColor.CGColor );
  CGContextSetStrokeColorWithColor(ctx, _trackColor.CGColor);
  CGContextMoveToPoint(ctx, x, y);
  CGContextAddArc(ctx, x, y, x,  radians(start), radians(finish), 1);
  CGContextFillPath(ctx);
  CGContextStrokePath(ctx);
  
  //Draw the shadow for center component
  CGContextSetFillColorWithColor( ctx, [UIColor colorWithWhite:.1 alpha:.4].CGColor );
  CGContextFillEllipseInRect( ctx, CGRectInset(self.bounds, CENTER_INSET-4, CENTER_INSET-4) );
  
  //Draw center transparent mask
  CGContextSetFillColorWithColor( ctx, [UIColor clearColor].CGColor );
  CGContextSetBlendMode(ctx, kCGBlendModeClear);
  CGContextFillEllipseInRect( ctx, CGRectInset(self.bounds, CENTER_INSET, CENTER_INSET) );
  
}

@end
