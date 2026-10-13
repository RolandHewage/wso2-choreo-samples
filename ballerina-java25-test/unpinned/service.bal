import ballerina/http;
import ballerina/jballerina.java;

configurable string greeting = "Hello";

# Returns a greeting together with the Java version the service runs on.
service /greeting on new http:Listener(9090) {
    resource function get .(string name = "World") returns json {
        return {
            message: string `${greeting}, ${name}!`,
            javaVersion: getJavaVersion()
        };
    }
}

function getJavaVersion() returns string {
    return java:toString(getSystemProperty(java:fromString("java.version"))) ?: "unknown";
}

function getSystemProperty(handle key) returns handle = @java:Method {
    'class: "java.lang.System",
    name: "getProperty"
} external;
