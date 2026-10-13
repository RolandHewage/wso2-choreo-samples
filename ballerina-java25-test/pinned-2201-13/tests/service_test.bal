import ballerina/http;
import ballerina/test;

final http:Client testClient = check new ("http://localhost:9090/greeting");

@test:Config {}
function testGreeting() returns error? {
    json response = check testClient->get("/?name=Choreo");
    test:assertEquals(check response.message, "Hello, Choreo!");
}
