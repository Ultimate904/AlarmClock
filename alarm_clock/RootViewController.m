#import "RootViewController.h"
#import "AlarmViewController.h"
#import "NightAlarmViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation RootViewController {
    AlarmViewController *_alarmViewController;
    NightAlarmViewController *_nightAlarmViewController;
    UISwipeGestureRecognizer *_swipeGestureReconizer;
}

@synthesize timePickers;
@synthesize hoursFill;
@synthesize minutesFill;
@synthesize sleepInMinutes;
@synthesize leftToSleepLabel;
@synthesize leftToSleepInMinutes;
@synthesize torchState;
@synthesize wakeUpLabel;
@synthesize leftToSleepTimeLabel;


-(IBAction)exitButtonPressed:(id)sender{
  //Cance all notification
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
  //Close app
  exit(0);
}

-(IBAction)torchButtonPressed:(id)sender{
  AVCaptureDevice* flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  if([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn]){
  BOOL succes = [flashLight lockForConfiguration:nil]; 
  //Enable if off
    if(!self.torchState){
      if(succes){
        [flashLight setTorchMode:AVCaptureTorchModeOn];
        [flashLight unlockForConfiguration];
        self.torchState = YES;
      }
    }else{    //Turn off when turned off
      if(succes){
        [flashLight setTorchMode:AVCaptureTorchModeOn];
        [flashLight unlockForConfiguration];
        self.torchState = NO;
      }
    }
  }
}


-(IBAction)alarmViewControllerButtonPressed:(id)sender {
  [self presentedViewControllerSwipeRight];
}

- (void)viewDidLoad {
  [super viewDidLoad];
    
  static NSArray *bufferHours;
  static NSArray* bufferMinutes;
    
  if(!bufferHours) {
    bufferHours = [[NSArray alloc] initWithObjects:@"00", @"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", nil];
  }
    
  if(!bufferMinutes) {
    bufferMinutes = [[NSArray alloc] initWithObjects:@"00", @"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",nil];
  }
  
  _swipeGestureReconizer = [[UISwipeGestureRecognizer alloc] init];
  [_swipeGestureReconizer addTarget:self action:@selector(onSwipe:)];
  [_swipeGestureReconizer setDirection:UISwipeGestureRecognizerDirectionLeft];
  [self.view addGestureRecognizer:_swipeGestureReconizer];
    
  [wakeUpLabel setText:NSLocalizedString(@"wake_up", nil)];
  //Set the background color
  UIColor* bacground = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
  self.view.backgroundColor = bacground;
    
  self.hoursFill = bufferHours;
  self.minutesFill = bufferMinutes;
    
  //Get the current time, and set it to pickers
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
  [dateFormatter setDateFormat:@"HH"];
  int hours = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
  [dateFormatter setDateFormat:@"mm"];
  int minutes = [[dateFormatter stringFromDate:[NSDate date]] intValue];
  
  //
  self.sleepInMinutes += (hours * MINUTES_PER_HOUR + minutes);
  self.sleepInMinutes += self.leftToSleepInMinutes;
  if(self.sleepInMinutes / MINUTES_PER_HOUR > HOURS_PER_DAY)
  self.sleepInMinutes -= HOURS_PER_DAY * MINUTES_PER_HOUR;
    
  //Set the current time or the time to wake up
  [timePickers selectRow:(self.sleepInMinutes / MINUTES_PER_HOUR) inComponent:HOURS_PIC animated:YES];
  [timePickers selectRow:(self.sleepInMinutes % MINUTES_PER_HOUR) inComponent:MINUTES_PIC animated:YES];
    
  [bufferHours release];
  [bufferMinutes release];
    
  leftToSleepLabel.text = NSLocalizedString(@"sleep_up_to", nil);

  //Get the time to wake up
  int leftTime = self.getLeftTime;
    
  if ([[NSUserDefaults standardUserDefaults] integerForKey:@"left_time"] != 0) {
      leftTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"left_time"];
  }

  leftToSleepTimeLabel.text = nil;
  leftToSleepTimeLabel.text = [NSString stringWithFormat:@"%02d : %02d", (int)(leftTime/ MINUTES_PER_HOUR), (int)(leftTime % MINUTES_PER_HOUR)];
    
  _alarmViewController = [[AlarmViewController alloc]initWithNibName:@"AlarmViewController" bundle:nil];
	
  //Crate the listener for rotation events
  [[NSNotificationCenter defaultCenter]addObserver:self
                                        selector:@selector(checkRotation:)
                                        name:UIApplicationDidChangeStatusBarOrientationNotification
                                        object: nil];
  [self setTorchState:NO];
}

- (void)onSwipe:(UISwipeGestureRecognizer *)recognizer {
  [self presentedViewControllerSwipeRight];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView
    numberOfRowsInComponent:(NSInteger)component {

  return INT16_MAX;
}

-(NSString*)pickerView:(UIPickerView *)pickerView
           titleForRow:(NSInteger)row
          forComponent:(NSInteger)component {
    
  if(component == HOURS_PIC)
    return [self.hoursFill objectAtIndex: row % [self.hoursFill count]];
  return [self.minutesFill objectAtIndex: row % [self.minutesFill count]];
}

-(void)checkRotation:(NSNotification*)notification {
  //If the turn, create Notification to alarm and transition to NightAlarmViewController
  UIInterfaceOrientation orientation = [[UIDevice currentDevice]orientation];
    
  if(orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight){
    UILocalNotification *notif = [[UILocalNotification alloc]init];
    notif.timeZone = [NSTimeZone localTimeZone];
    notif.fireDate = [[NSDate date] dateByAddingTimeInterval:self.getLeftTime*60];
    notif.alertBody = @"Wake up, time to get up?";
    notif.alertAction = @"Yes";
    notif.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
 
    //Create NightAlarmViewController and send data
    _nightAlarmViewController = [[NightAlarmViewController alloc] initWithNibName:@"NightAlarmViewController" bundle:nil];
    [_nightAlarmViewController setLeftTime: self.getLeftTime];
    [_nightAlarmViewController setClockTime: [timePickers selectedRowInComponent: HOURS_PIC] * MINUTES_PER_HOUR + 1 +[timePickers selectedRowInComponent: MINUTES_PIC]-1];
          
    //Transition to NightAlarmViewController
    [self presentViewController:_nightAlarmViewController animated:YES completion:nil];
  }
}

- (void)presentedViewControllerSwipeRight {
  CATransition *animation = [CATransition animation];
  [animation setDuration:0.3f];
  [animation setType:kCATransitionPush];
  [animation setSubtype:kCATransitionFromRight];
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  [[_alarmViewController.view layer] addAnimation:animation forKey:@"SwitchToView"];
  //Alternativnyye make active mode time selection
  [_alarmViewController setLeftToSleepInMinutes : self.getLeftTime];
  [_alarmViewController setSleepInMinutes:[timePickers selectedRowInComponent: HOURS_PIC] * MINUTES_PER_HOUR + 1 +[timePickers selectedRowInComponent: MINUTES_PIC]-1];
  [self presentViewController:_alarmViewController animated:NO completion:nil];;
}


- (IBAction)startAlarmButtonPressed:(id)sender {
  //Create alarm notification
  UILocalNotification *notif = [[UILocalNotification alloc]init];
  notif.timeZone = [NSTimeZone localTimeZone];
  notif.fireDate = [[NSDate date] dateByAddingTimeInterval:self.getLeftTime*60];
  notif.alertBody = @"Wake up, time to get up?";
  notif.alertAction = @"Yes";
  notif.soundName = UILocalNotificationDefaultSoundName;
  [[UIApplication sharedApplication] scheduleLocalNotification:notif];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)componen {
  int leftTime = self.getLeftTime;
  leftToSleepTimeLabel.text = [NSString stringWithFormat:@"%02d : %02d", (int)(leftTime/ MINUTES_PER_HOUR), (int)(leftTime % MINUTES_PER_HOUR)];
}

- (int)getLeftTime {
  //Get the current time  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
  [dateFormatter setDateFormat:@"HH"];
  int hours = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
  [dateFormatter setDateFormat:@"mm"];
  int minutes = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
  //translate hours to minutes 
  int curentTime = hours*MINUTES_PER_HOUR+minutes;
  int alarmTime = (([timePickers selectedRowInComponent: HOURS_PIC]%[self.hoursFill count]) * MINUTES_PER_HOUR) + ([timePickers selectedRowInComponent: MINUTES_PIC]%[self.minutesFill count]);
    
  self.sleepInMinutes = alarmTime;
  
  //Calculating the remaining time to wake up
  int leftTime;
  if(curentTime <= alarmTime) {
    leftTime = alarmTime - curentTime;
  }
  else {
    leftTime = alarmTime + (HOURS_PER_DAY * MINUTES_PER_HOUR - curentTime);
  }
    
  [[NSUserDefaults standardUserDefaults] setInteger:(leftTime) forKey:@"left_time"];
    
  return leftTime;
}

-(UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
  return UIInterfaceOrientationPortrait;
}

-(BOOL) shouldAutorotate {
  return YES;
}

-(NSUInteger) supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll;
}

@end
