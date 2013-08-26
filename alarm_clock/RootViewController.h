#define HOURS_PIC 0
#define MINUTES_PIC 1
#define MINUTES_PER_HOUR 60
#define HOURS_PER_DAY 24

#import <UIKit/UIKit.h>
@class AlarmViewController;
@class NightAlarmViewController;

@interface RootViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel* leftToSleepLabel;
@property (strong, nonatomic) IBOutlet UILabel* leftToSleepTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel* wakeUpLabel;
@property (strong, nonatomic) IBOutlet UIPickerView* timePickers;
@property (strong, nonatomic) NSArray* hoursFill;
@property (strong, nonatomic) NSArray* minutesFill;
@property (nonatomic) int sleepInMinutes;
@property (nonatomic) int leftToSleepInMinutes;
@property (nonatomic) BOOL torchState;


//create alarm
-(IBAction)startAlarmButtonPressed:(id)sender;

//cancel alarm notification
-(IBAction)exitButtonPressed:(id)sender;

//turn on/off the flashlight
-(IBAction)torchButtonPressed:(id)sender;

//Transition to AlarmViewControlle if button pressed
-(IBAction)alarmViewControllerButtonPressed:(id)sender;

//CenterNotification of rotation device
-(void)checkRotation:(NSNotification*)notification;

//Get the remaining time to wake up
-(int)getLeftTime;

@end
