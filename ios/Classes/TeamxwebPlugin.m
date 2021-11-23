#import "TeamxwebPlugin.h"
#if __has_include(<teamxweb/teamxweb-Swift.h>)
#import <teamxweb/teamxweb-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "teamxweb-Swift.h"
#endif

@implementation TeamxwebPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTeamxwebPlugin registerWithRegistrar:registrar];
}
@end
