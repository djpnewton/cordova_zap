/********* zap.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

#import "zap.h"

@interface zap : CDVPlugin {
  // Member variables go here.
}

- (void)version:(CDVInvokedUrlCommand*)command;
- (void)mnemonicCreate:(CDVInvokedUrlCommand*)command;
- (void)mnemonicCheck:(CDVInvokedUrlCommand*)command;
- (void)seedAddress:(CDVInvokedUrlCommand*)command;
- (void)addressBalance:(CDVInvokedUrlCommand*)command;
- (void)addressTransactions:(CDVInvokedUrlCommand*)command;
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

- (void)addressBalance:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    NSString* address = [command.arguments objectAtIndex:0];

    if (address != nil && [address length] > 0) {
        const char *c_address = [address cStringUsingEncoding:NSUTF8StringEncoding];
        struct int_result_t result = lzap_address_balance(c_address);
        if (result.success)
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:result.value];
        else
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)addressTransactions:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    NSString *address = [command.arguments objectAtIndex:0];
    NSNumber *limit = [command.arguments objectAtIndex:1];

    if (address != nil && [address length] > 0) {
        const char *c_address = [address cStringUsingEncoding:NSUTF8StringEncoding];
        struct tx_t *txs = malloc(sizeof(txs) * limit.intValue);
        if (!txs)
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        else {
            struct int_result_t result = lzap_address_transactions(c_address, txs, limit.intValue);
            if (result.success) {
                NSMutableArray *tx_array = [NSMutableArray array];
                for (int i = 0; i < result.value; i++) {
                    //NSMutableDictionary *tx = [NSMutableDictionary dictionary];
                    NSDictionary *tx = @{
                        @"id" : [NSString stringWithUTF8String:txs[i].id],
                        @"sender" : [NSString stringWithUTF8String:txs[i].sender],
                        @"recipient" : [NSString stringWithUTF8String:txs[i].recipient],
                        @"asset_id" : [NSString stringWithUTF8String:txs[i].asset_id],
                        @"fee_asset" : [NSString stringWithUTF8String:txs[i].fee_asset],
                        @"attachment" : [NSString stringWithUTF8String:txs[i].attachment],
                        @"amount" : [NSNumber numberWithUnsignedLongLong:txs[i].amount],
                        @"fee" : [NSNumber numberWithUnsignedLongLong:txs[i].fee],
                        @"timestamp" : [NSNumber numberWithUnsignedLongLong:txs[i].timestamp]
                    };
                    [tx_array addObject:tx];
                }
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:tx_array];
            }
            else
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            free(txs);
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
