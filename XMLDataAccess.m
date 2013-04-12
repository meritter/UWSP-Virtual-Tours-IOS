//
//  XMLDataAccess.m
//  UWSP Virtual Tours
//
//  Created by Jonathan Christian on 4/10/13.
//  Copyright (c) 2013 UWSP GIS All rights reserved.
//

#import "XMLDataAccess.h"
#import "XmlArrayParser.h"
#import "Poi.h"
#import "Singleton.h"

@implementation XMLDataAccess


@synthesize parsedMapPack;



-(void)setUpPOI:currentMapPack
{
parsedMapPack = [[NSMutableArray alloc] init];

//Find the .xml file associated to the currentMapPack
NSString * stringURL = [NSString stringWithFormat:@"%@%@", currentMapPack, @".xml"];

NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString *documentsDirectory = [paths objectAtIndex:0];

NSString *filePath = [documentsDirectory stringByAppendingPathComponent:stringURL];
NSData *data = [NSData dataWithContentsOfFile:filePath];

XmlArrayParser *parser = [[XmlArrayParser alloc] initWithData:data];

//get pois points from array in XML starting with <poi> tag
parser.rowElementName = @"poi";
parser.elementNames = [NSArray arrayWithObjects: @"description", @"id", @"lat", @"long", @"title", nil];


BOOL success = [parser parse];

//If parse was successful send items to Array
if (success)
{
    parsedMapPack = [parser items];
}


      [[Singleton sharedSingleton].locationsArray removeAllObjects];
    
for (int i = 0; i < [parsedMapPack count]; i++)
{
    //Create a dictionary and set to the count of i
    NSDictionary *tempObjectDict = [parsedMapPack objectAtIndex:i];
    
    //Create and initialize a poi object
    Poi * poi = [[Poi alloc] init];
    
    //Assign based upon dictionary key value pairs
    poi.title = [tempObjectDict objectForKey:@"title"];
    poi.lat = [tempObjectDict objectForKey:@"lat"];
    poi.lon = [tempObjectDict objectForKey:@"long"];
    
    //Add poi to singleton for App use
    [[Singleton sharedSingleton].locationsArray  addObject:poi];
    
   
}
    for ( Poi * poi in [Singleton sharedSingleton].locationsArray)
    {
        NSLog(@"Poi:  %@", poi.title);
        NSLog(@"Poi:  %@", poi.description);
        
    }
}


@end
