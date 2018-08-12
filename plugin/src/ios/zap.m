/********* zap.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

#import "zap.h"

@interface zap : CDVPlugin {
  // Member variables go here.
}

- (void)coolMethod:(CDVInvokedUrlCommand*)command;
@end

@implementation zap

- (void)version:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    int version = lzap_version();
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:version];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)mnemonicCreate:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    char c_mnemonic[1024];
    int result = lzap_mnemonic_create(c_mnemonic, 1024);
    if (result) {
        NSString *mnemonic = [NSString stringWithUTF8String:c_mnemonic];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:mnemonic];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)mnemonicCheck:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* mnemonic = [command.arguments objectAtIndex:0];

    if (mnemonic != nil && [mnemonic length] > 0) {
        const char *c_mnemonic = [mnemonic cStringUsingEncoding:NSUTF8StringEncoding];
        int result = lzap_mnemonic_check(c_mnemonic);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:result];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)seedAddress:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    NSString* seed = [command.arguments objectAtIndex:0];

    if (seed != nil && [seed length] > 0) {
        const char *c_seed = [seed cStringUsingEncoding:NSUTF8StringEncoding];
        char c_address[1024];
        lzap_seed_address(c_seed, c_address);
        NSString *address = [NSString stringWithUTF8String:c_address];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:address];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
