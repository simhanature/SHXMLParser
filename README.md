## SHXMLParser

Easy to use automatic XML Parser built on NSXMLParser. Convert your XML data into native 'Obj C object' in just 2 steps.

**How To Use:**

Add the library folder SHXMLParser to your project.

**XML Sample**
``` xml
<rss>
    <channel>
        <item id='1'>
            <title>I am under surveillance by Canadian agents, my computer has been backdoored</title>
            <link>http://log.nadim.cc/?p=110</link>
            <comments>http://news.ycombinator.com/item?id=5194489</comments>
            <description><a href="http://news.ycombinator.com/item?id=5194489">Comments</a></description>
        </item>
        <item id='2'>
            <title>Why I Like Go</title>
            <link>https://gist.github.com/freeformz/4746274</link>
            <description><a href="http://news.ycombinator.com/item?id=5195257">Comments</a></description>
        </item>
    </channel>
</rss>
```

Use the below code to get the Array of Dictionary Objects from an XML like the one above. 
Attributes will be taken automatically.

``` objc
SHXMLParser		*parser			= [[SHXMLParser alloc] init];
NSDictionary	*resultObject	= [parser parseData:self.webServicesData];
NSArray			*dataArray		= [SHXMLParser getDataAtPath:@"rss.channel.item" fromResultObject:resultObject];
```

Note: In case, the path used ("rss.channel.item") contains only one item, NSDictionary will be returned instead of NSArray. If the path leads to leaf with just a string value,
    string value will be returned.

If you want to convert dictionary objects in your data array into a class object for type safety, use code below.

``` objc
NSArray *classVariables = [NSArray arrayWithObjects:@"title", @"link", @"comments", @"description", nil];
self.dataItems = [SHXMLParser convertDictionaryArray:dataArray toObjectArrayWithClassName:@"DataItem" classVariables:classVariables];
```

Note that for above conversion, class named 'DataItem' should contain public variables as mentioned in array 'classVariables', otherwise you will get runtime error.

Thats it, no need to write lot of node and element specific parsing code to retrieve data using NSXMLParser from XML data.

**Requirements**
It requires iOS 5.0+ and uses ARC. It is built and tested using Xcode 4.5+.

Feel free to fork and update the library

**License**
MIT License
