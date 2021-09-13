//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_isolate/FlutterIsolatePlugin.h>)
#import <flutter_isolate/FlutterIsolatePlugin.h>
#else
@import flutter_isolate;
#endif

#if __has_include(<flutter_js/FlutterJsPlugin.h>)
#import <flutter_js/FlutterJsPlugin.h>
#else
@import flutter_js;
#endif

#if __has_include(<webview_flutter/FLTWebViewFlutterPlugin.h>)
#import <webview_flutter/FLTWebViewFlutterPlugin.h>
#else
@import webview_flutter;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FlutterIsolatePlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterIsolatePlugin"]];
  [FlutterJsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterJsPlugin"]];
  [FLTWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTWebViewFlutterPlugin"]];
}

@end
