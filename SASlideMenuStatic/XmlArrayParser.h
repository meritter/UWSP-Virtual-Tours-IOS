//
//  ArrayParser.h
//  NSXMLParser ARC Demonstration
//
//  Created by Robert Ryan on 12/20/12.
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

#import <Foundation/Foundation.h>

@interface XmlArrayParser : NSObject

@property (nonatomic, strong) NSString *rowElementName; // this is the element name that identifies a new row of data in the XML
@property (nonatomic, strong) NSArray *attributeNames;  // this is the array of attributes we might want to retrieve for that element name
@property (nonatomic, strong) NSArray *elementNames;    // this is the list of sub element names for which we're retrieving values

@property (nonatomic, strong) NSMutableArray *items;    // after parsing, this is the array of parsed items

// we'll define three initializers that look like NSXmlParser's initializers

- (id)initWithContentsOfURL:(NSURL *)url;
- (id)initWithData:(NSData *)data;
- (id)initWithStream:(NSInputStream *)stream;

// and we'll define a parse method that will initiate the parse

- (BOOL)parse;

@end
