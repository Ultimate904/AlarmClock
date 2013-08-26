#import "AlarmViewController.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation AlarmViewController {
    RootViewController* _rootViewController;
    UISwipeGestureRecognizer *_swipeGestureReconizer;
}
@synthesize sleepSlider;
@synthesize outTime;
@synthesize sleepInMinutes;
@synthesize leftToSleepInMinutes;
@synthesize time;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName : nibNameOrNil bundle : nibBundleOrNil];
  if (self) {

  }
  return self;
}

- (IBAction)sliderValueChanged:(id)sender {
 int hours = round([(UISlider*)sender value]);
    
 outTime.text = [NSString stringWithFormat:@"%@ %02d h. %02d %@.", NSLocalizedString(@"left_to_sleep", nil), (int)(hours / MINUTES_PER_HOUR), (hours % MINUTES_PER_HOUR), NSLocalizedString(@"min", nil)];

 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
 [dateFormatter setDateFormat:@"HH"];
 int hoursBuff = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
 [dateFormatter setDateFormat:@"mm"];
 int minutes = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
 int tmpTime = hours + (hoursBuff * 60 +minutes);
    
 if(tmpTime > HOURS_PER_DAY*MINUTES_PER_HOUR)
    tmpTime -= HOURS_PER_DAY*MINUTES_PER_HOUR;
    
 time.text = [NSString stringWithFormat:@"%@ %02d:%02d", NSLocalizedString(@"alarm_rings_in", nil), tmpTime/60 , tmpTime%60];
}

- (IBAction)transitionForRootViewControllerPressed:(id)sender {
  [self presentedViewControllerSwipeLeft];
}

- (void) presentedViewControllerSwipeLeft {
  CATransition *animation = [CATransition animation];
  [animation setDuration:0.3f];
  [animation setType:kCATransitionPush];
  [animation setSubtype:kCATransitionFromLeft];
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  [[_rootViewController.view layer] addAnimation:animation forKey:@"SwitchToView"];
  [_rootViewController setLeftToSleepInMinutes : round(sleepSlider.value)];
  [self presentViewController:_rootViewController animated:NO completion:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _swipeGestureReconizer = [[UISwipeGestureRecognizer alloc] init];
  [_swipeGestureReconizer setDirection:UISwipeGestureRecognizerDirectionRight];
  [_swipeGestureReconizer addTarget:self action:@selector(onSwipe:)];
  [self.view addGestureRecognizer:_swipeGestureReconizer];
    
  //Set the background color
  UIColor* bacground = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
  self.view.backgroundColor = bacground;
    
  int hours = self.leftToSleepInMinutes;
    
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
  [dateFormatter setDateFormat:@"HH"];
  int hoursBuff = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
  [dateFormatter setDateFormat:@"mm"];
  int minutes = [[dateFormatter stringFromDate:[NSDate date]] intValue];
  
  //translate hours to minutes
  int tmpTime = hours + (hoursBuff * MINUTES_PER_HOUR +minutes);
    
  //consider how much time is left before the alarm
  if(tmpTime > HOURS_PER_DAY * MINUTES_PER_HOUR)
    tmpTime -= HOURS_PER_DAY * MINUTES_PER_HOUR;

  time.text = [NSString stringWithFormat:@"%@ %02d:%02d", NSLocalizedString(@"alarm_rings_in", nil), tmpTime/60 , tmpTime%60];
    
  [sleepSlider setValue:self.leftToSleepInMinutes];
    
  outTime.text = [NSString stringWithFormat:@"%@ %02d h. %02d %@", NSLocalizedString(@"left_to_sleep", nil), self.leftToSleepInMinutes / MINUTES_PER_HOUR, self.leftToSleepInMinutes % MINUTES_PER_HOUR,NSLocalizedString(@"min", nil)];

  _rootViewController = [[RootViewController alloc]initWithNibName:@"RootViewController" bundle:nil];
}

- (void)onSwipe:(UISwipeGestureRecognizer *)recognizer {
  [self presentedViewControllerSwipeLeft];
}

- (void)didReceiveMemoryWarning{
  [super didReceiveMemoryWarning];
}

-(UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
  return UIInterfaceOrientationPortrait;
}

-(BOOL) shouldAutorotate {
  return NO;
}

-(NSUInteger) supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll;
}

@end
