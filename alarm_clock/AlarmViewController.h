#define MINUTES_PER_HOUR 60

#import <UIKit/UIKit.h>
@class RootViewController;

@interface AlarmViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISlider* sleepSlider;
@property (strong, nonatomic) IBOutlet UILabel* outTime;
@property (strong, nonatomic) IBOutlet UILabel* time;
@property (nonatomic) int sleepInMinutes;
@property (nonatomic) int leftToSleepInMinutes;

//
-(IBAction) transitionForRootViewControllerPressed:(id)sender;

//
-(IBAction) sliderValueChanged:(id)sender;


@end
