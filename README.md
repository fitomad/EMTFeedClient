# EMTFeedClient
Cliente para el feed de incidencias de la EMT de Madrid

## ¿Cómo se usa?
Vamos a ver un ejemplo, en este caso un test en el que recuperamos el **feed** de incidencias

```swift
func testRequest()
{
    let expectation: XCTestExpectation = self.expectationWithDescription("Test EMT Feed...")
    
    EMTFeedClient.sharedInstance.requestTransitIncidents({ (result) -> (Void) in
        switch result
        {
            case let FeedResult.Success(feed):
                if let incidents = feed.incidents where !incidents.isEmpty
                {
                    print("$Encontradas \(incidents.count) incidencias")
                    
                    for (index, incident) in incidents.enumerate()
                    {
                        print("\t\(index). \(incident.title)")
                    }
                }
                else
                {
                    print("$Vacio :(")
                }
            
            case let FeedResult.Error(message):
                print("#Error: \(message)")
        }

        
        expectation.fulfill()
    })
    
    self.waitForExpectationsWithTimeout(5000, handler: nil)
}
```
