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
    poi.lat = [[tempObjectDict objectForKey:@"lat"] doubleValue];
    poi.lon = [[tempObjectDict objectForKey:@"long"] doubleValue];
    poi.description = [tempObjectDict objectForKey:@"description"];
    poi.poiId = [[tempObjectDict objectForKey:@"id"] integerValue];

        
       // poi.visited = true;
    //Add poi to singleton for App use
    [[Singleton sharedSingleton].locationsArray  addObject:poi];
   
    }
}


//Get the <image> xml tag in each poi and set up each image to be downloaded and saved in the
//devices documents directory
-(void)downloadImagesOfMapPack:currentMapPack
{
    NSString * stringURL = [NSString stringWithFormat:@"%@%@", currentMapPack, @".xml"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:stringURL];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    XmlArrayParser *parser = [[XmlArrayParser alloc] initWithData:data];
    
    //get pois points from array in XML starting with <poi> tag
    parser.rowElementName = @"image";
    parser.elementNames = [NSArray arrayWithObjects: @"description", @"url", @"poi-id", nil];
   // parser
  
    
    BOOL success = [parser parse];
    
    //If parse was successful send items to Array
    if (success)
    {
        parsedMapPack = [parser items];
    }

        
    for (int i = 0; i < [parsedMapPack count]; i++)
    {
        
            NSDictionary *tempObjectDict = [parsedMapPack objectAtIndex:i];
        
            NSString * path = [tempObjectDict objectForKey:@"url"];
            int poiId =  [[tempObjectDict objectForKey:@"poi-id"] integerValue];
            int lastPoiId =  poiId;
       
          //Does a check if the same poi has more than one image - if it does we up the count
          // 12-0.png would have 12-1.png as well
        if  (poiId == lastPoiId)
        {
            int imagecount = 0;
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: path]];
            UIImage *image = [UIImage imageWithData: imageData];
            
            
            NSString * stringURL = [NSString stringWithFormat:@"%d-%d%@", lastPoiId, imagecount, @".png"];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:stringURL];
            
            NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
            NSError *writeError = nil;
            
            [data1 writeToFile:filePath options:NSDataWritingAtomic error:&writeError];
            
            if (writeError) {
                NSLog(@"Error writing file: %@", writeError);
            }
            imagecount++;

        }
        else
        {
           //Assign it a new id
            int imagecount = 0;
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: path]];
            UIImage *image = [UIImage imageWithData: imageData];
        
        
           NSString * stringURL = [NSString stringWithFormat:@"%d-%d%@", poiId, imagecount, @".png"];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:stringURL];
            
            NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
            NSError *writeError = nil;
            
            [data1 writeToFile:filePath options:NSDataWritingAtomic error:&writeError];
            
            if (writeError) {
                NSLog(@"Error writing file: %@", writeError);
            }
        }
    }
}
@end
