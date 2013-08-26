#import "NightAlarmViewController.h"
#import "RootViewController.h"

@implementation NightAlarmViewController {
    RootViewController* _rootViewController;
}

@synthesize clockTime;
@synthesize timeDial;
@synthesize time;
@synthesize alarmTime;
@synthesize leftTime;


- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) timerFired : (NSTimer*)timer
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"HH"];
    int hours = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
    [dateFormatter setDateFormat:@"mm"];
    int minutes = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
    timeDial.text = [NSString stringWithFormat:@"%02d:%02d", hours, minutes];
    
    int buffTime;
    int curentTime = hours * MINUTES_PER_HOUR + minutes;
    
    //consider how much time is left before the alarm
    if(curentTime <= self.clockTime){
        buffTime = self.clockTime - curentTime;
    }else{
        buffTime = self.clockTime + (HOURS_PER_DAY * MINUTES_PER_HOUR - curentTime);
    }
    
    //if time > 1 hour then color = green
    //else color = red
    if(buffTime <= MINUTES_PER_HOUR){
        alarmTime.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    }else{
        alarmTime.textColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    }
    
    //get left time
    self.leftTime = buffTime;
    alarmTime.text = [NSString stringWithFormat:@"%@ %02d h. %02d %@.", NSLocalizedString(@"sleep_up_to", nil), (int)(buffTime /  MINUTES_PER_HOUR), buffTime % MINUTES_PER_HOUR, NSLocalizedString(@"min", nil)];

}

- (void)viewDidLoad{
  [super viewDidLoad];

  //Set the background color
  UIColor* bacground = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
  self.view.backgroundColor = bacground;
    
  [[NSNotificationCenter defaultCenter]addObserver:self
                                        selector:@selector(checkRotation:)
                                        name:UIApplicationDidChangeStatusBarOrientationNotification
                                        object: nil];
    
  self.time = [NSTimer scheduledTimerWithTimeInterval:1
                                        target: self
                                        selector:@selector(timerFired:)
                                        userInfo: nil
                                        repeats:YES];
    
  [[UIDevice currentDevice]setBatteryMonitoringEnabled:YES];
  [[UIDevice currentDevice]batteryState];
    
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(batteryStatus) name:UIDeviceBatteryStateDidChangeNotification object: nil];
}

- (void)didReceiveMemoryWarning{
  [super didReceiveMemoryWarning];
}

-(void) batteryStatus:(NSNotification*)notification{
  //If the charge off sleep mode
  if([[UIDevice currentDevice]batteryState]==UIDeviceBatteryStateCharging)
    [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
  else
    [[UIApplication sharedApplication]setIdleTimerDisabled:NO];
}

-(void)checkRotation:(NSNotification*)notification{
  UIInterfaceOrientation orientation = [[UIDevice currentDevice]orientation];
  if(orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown){
    _rootViewController = [[RootViewController alloc]initWithNibName:@"RootViewController" bundle:nil];
    _rootViewController.leftToSleepInMinutes = self.leftTime;
    [self presentViewController:_rootViewController animated:YES completion:nil];
  }
}



-(UIInterfaceOrientation) preferredInterfaceOrientationForPresentation{
  return UIInterfaceOrientationLandscapeRight;
}

-(BOOL) shouldAutorotate{
  return YES;
}

-(NSUInteger) supportedInterfaceOrientations{
  return UIInterfaceOrientationMaskAll;
}

@end
