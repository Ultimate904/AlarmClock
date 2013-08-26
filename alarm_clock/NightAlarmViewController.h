#define MINUTES_PER_HOUR 60

#import <UIKit/UIKit.h>
@class RootViewController;

@interface NightAlarmViewController : UIViewController

@property (nonatomic) int leftTime;
@property (nonatomic) int clockTime;
@property (nonatomic, strong) NSTimer* time;
@property (nonatomic, strong) IBOutlet UILabel* timeDial;
@property (nonatomic, strong) IBOutlet UILabel* alarmTime;

//If the charge off sleep mode
-(void) batteryStatus:(NSNotification*)notification;

//
-(void) checkRotation:(NSNotification*)notification;

//CenterNotification of rotation device
-(void) timerFired:(NSTimer*)timer;

@end
