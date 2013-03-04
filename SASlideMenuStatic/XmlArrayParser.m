//
//  ArrayParser.m
//  NSXMLParser ARC Demonstration
//
//  Created by Robert Ryan on 12/20/12.
//
//  Copyright (c) 2012 Robert M. Ryan. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "XmlArrayParser.h"

@interface XmlArrayParser () <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableDictionary *item;     // while parsing, this is the item currently being parsed
@property (nonatomic, strong) NSMutableString *elementValue; // this is the element within that item being parsed
@property (nonatomic, strong) NSXMLParser *parser;           // this is the actual parser

@end

@implementation XmlArrayParser

- (void)dealloc
{
    _parser.delegate = nil;
    _parser = nil;
}

- (id)initWithContentsOfURL:(NSURL *)url
{
    self = [super init];
    
    if (self)
    {
        _parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        _parser.delegate = self;
    }
    
    return self;
}

- (id)initWithData:(NSData *)data
{
    self = [super init];
    
    if (self)
    {
        _parser = [[NSXMLParser alloc] initWithData:data];
        _parser.delegate = self;
    }

    return self;
}

- (id)initWithStream:(NSInputStream *)stream
{
    self = [super init];
    
    if (self)
    {
        _parser = [[NSXMLParser alloc] initWithStream:stream];
        _parser.delegate = self;
    }

    return self;
}

- (BOOL)parse
{
    return [self.parser parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.items = [[NSMutableArray alloc] init];
    
    if (!self.rowElementName)
        NSLog(@"%s Warning: Failed to specify row identifier element name", __FUNCTION__);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:self.rowElementName])
    {
        self.item  = [[NSMutableDictionary alloc] init];
        
        for (NSString *attributeName in self.attributeNames)
        {
            id attributeValue = [attributeDict valueForKey:attributeName];
            if (attributeValue)
                [self.item setObject:attributeValue forKey:attributeName];
        }
    }
    else if ([self.elementNames containsObject:elementName])
    {
        self.elementValue = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.elementValue)
    {
        [self.elementValue appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:self.rowElementName])
    {
        [self.items addObject:self.item];
        self.item = nil;
    }
    else if ([self.elementNames containsObject:elementName])
    {
        [self.item setValue:self.elementValue forKey:elementName];
        self.elementValue = nil;
    }
}

@end
