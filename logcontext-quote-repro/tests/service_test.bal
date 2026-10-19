import ballerina/http;
import ballerina/test;

final http:Client testClient = check new ("http://localhost:9090/repro");

@test:Config {}
function testEveryPrintedLineIsValidJson() returns error? {
    json[] results = check testClient->get("/all");
    test:assertEquals(results.length(), cases.length());
    foreach json result in results {
        string printed = check result.printed;
        json parsed = check printed.fromJsonString();
        test:assertEquals(check parsed.level, "ERROR");
    }
}

@test:Config {}
function testQuoteCase() returns error? {
    json result = check testClient->get("/quote");
    test:assertEquals(check result.beforeFix, "{}");
    string printed = check result.printed;
    test:assertTrue(printed.includes("t;desc=\\\"abc\\\""));
}

@test:Config {}
function testUnknownCase() returns error? {
    http:Response response = check testClient->get("/unknown");
    test:assertEquals(response.statusCode, http:STATUS_NOT_FOUND);
}
