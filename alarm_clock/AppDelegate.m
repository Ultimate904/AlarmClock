#import "AppDelegate.h"

#import "RootViewController.h"
@interface AppDelegate () <UIAlertViewDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.viewController = [[[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    UIAlertView * alerView = [[UIAlertView alloc] initWithTitle:@"Wake Up!"
                                                            message:notification.alertBody
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:@"Cancel", nil];
    [alerView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

- (void)dealloc {
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
