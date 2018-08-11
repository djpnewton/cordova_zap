/********* zap.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

#import "zap.h"

@interface zap : CDVPlugin {
  // Member variables go here.
}

- (void)coolMethod:(CDVInvokedUrlCommand*)command;
@end

@implementation zap

- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)version:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    int version = lzap_version();
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:version];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
