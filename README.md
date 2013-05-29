## SHXMLParser

Simple to use automatic XML Parser built on NSXML Parser.

Download the class files for SHXMLParser (SHXMLParser.h & SHXMLParser.m)

**XML Sample**

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

Use the below code to get the Array of Dictionary Objects from an XML like the one above. 
There is no need to mention attributes names as they will be taken automatically.

``` objc
NSArray *classVariables = [[NSArray arrayWithObjects:@"title", @"link", @"comments", @"description", nil] autorelease];
SHXMLParser *parser = [[SHXMLParser alloc] init];
NSMutableArray* myDataArray = [parser parseData:self.webServicesData withArrayPath:@"channel.item" andItemKeys:classVariables];
```

If you want to convert dictionary object into a class object, use code below.

``` objc
self.dataItems = [SHXMLParser convertDictionary:myDataArray toObjectArrayWithClassName:@"DataItem" classVariables:classVariables];
```

Note that for above conversion, class named 'DataItem' should contain public variables as mentioned in array class variables, else you will get runtime error.

Thats it, no need to write lots of parsing code to get xml data from NSXMLParser.
