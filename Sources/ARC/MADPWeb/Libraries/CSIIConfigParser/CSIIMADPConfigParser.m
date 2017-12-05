//
//  CSIIMADPConfigParser.m
//  CSIIPlatformLib
//
//  Created by liurenpeng on 6/18/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CSIIMADPConfigParser.h"
@interface CSIIMADPConfigParser ()

@property (nonatomic, readwrite, strong) NSMutableDictionary* pluginsDict;
@property (nonatomic, readwrite, strong) NSMutableDictionary* settings;
@property (nonatomic, readwrite, strong) NSMutableArray* whitelistHosts;
@property (nonatomic, readwrite, strong) NSMutableArray* startupPluginNames;
@property (nonatomic, readwrite, strong) NSString* startPage;

@end
@implementation CSIIMADPConfigParser
@synthesize pluginsDict, settings, whitelistHosts, startPage, startupPluginNames;
- (id)init
{
    self = [super init];
    if (self != nil) {
        self.pluginsDict = [[NSMutableDictionary alloc] initWithCapacity:30];
        self.settings = [[NSMutableDictionary alloc] initWithCapacity:30];
        self.whitelistHosts = [[NSMutableArray alloc] initWithCapacity:30];
        self.startupPluginNames = [[NSMutableArray alloc] initWithCapacity:8];
        featureName = nil;
    }
    return self;
}

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"preference"]) {
//        settings[[attributeDict[@"name"] lowercaseString]] = attributeDict[@"value"];
        
        settings[attributeDict[@"name"]] = attributeDict[@"value"];

    } else if ([elementName isEqualToString:@"plugin"]) {
        NSString* name = attributeDict[@"name"];//[attributeDict[@"name"] lowercaseString];
        pluginsDict[name] = attributeDict[@"value"];
        if ([@"true" isEqualToString : attributeDict[@"onload"]]) {
            [self.startupPluginNames addObject:name];
        }
        DebugLog(@"\nUse of the <plugin> tag has been deprecated. Use a <feature> tag instead. Change:\n"
              @"    <plugin name=\"%@\" value=\"%@\" />\n"
              @"To:\n"
              @"    <feature name=\"%@\">\n"
              @"        <param name=\"ios-package\" value=\"%@\" />\n"
              @"    </feature>\n"
              , attributeDict[@"name"], attributeDict[@"value"], attributeDict[@"name"], attributeDict[@"value"]);
    } else if ([elementName isEqualToString:@"feature"]) { // store feature name to use with correct parameter set
        featureName = attributeDict[@"name"];//[attributeDict[@"name"] lowercaseString];
    } else if ((featureName != nil) && [elementName isEqualToString:@"param"]) {
        NSString* paramName = attributeDict[@"name"];//[attributeDict[@"name"] lowercaseString];
        id value = attributeDict[@"value"];
        if ([paramName isEqualToString:@"ios-package"]) {
            pluginsDict[featureName] = value;
        }
        if ([paramName isEqualToString:@"onload"] && [@"true" isEqualToString : value]) {
            [self.startupPluginNames addObject:featureName];
        }
    } else if ([elementName isEqualToString:@"access"]) {
        [whitelistHosts addObject:attributeDict[@"origin"]];
    } else if ([elementName isEqualToString:@"content"]) {
        self.startPage = attributeDict[@"src"];
    }
}

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName
{
    if ([elementName isEqualToString:@"feature"]) { // no longer handling a feature so release
        featureName = nil;
    }
}

- (void)parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError
{
    NSAssert(NO, @"config.xml parse error line %ld col %ld", (long)[parser lineNumber], (long)[parser columnNumber]);
}
@end
