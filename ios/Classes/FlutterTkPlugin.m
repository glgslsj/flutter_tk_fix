#import "FlutterTkPlugin.h"
#if __has_include(<flutter_tk/flutter_tk-Swift.h>)
#import <flutter_tk/flutter_tk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_tk-Swift.h"
#endif

@implementation FlutterTkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterTkPlugin registerWithRegistrar:registrar];
}
@end
