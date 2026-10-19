import ballerina/http;
import ballerina/io;
import ballerina/time;

# Each case is the context part of a JSON log line. Cases marked true contain a
# character that must be escaped in JSON: a double quote, a newline or a backslash.
final readonly & map<[boolean, map<json>]> cases = {
    "quote": [true, {"error": {"message": "x", "detail": {"headers": {"server-timing": ["t;desc=\"abc\", sem_wait;dur=0"]}}}}],
    "newline": [true, {"stackTrace": "error: x\n\tat module:fn(service.bal:10)\n\tat module:main(main.bal:3)"}],
    "backslash": [true, {"path": "C:\\temp\\app.log"}],
    "no-quote": [false, {"error": {"message": "x", "detail": {"headers": {"server-timing": ["t;desc=abc, sem_wait;dur=0"], "set-cookie": ["a=b; Path=/; Secure"]}}}}],
    "nested": [false, {"body": {"items": [{"id": 1, "name": "one"}, {"id": 2, "name": "two"}]}}]
};

# Prints JSON log lines to stdout so they show up in Observability > Runtime Logs.
service /repro on new http:Listener(9090) {

    # Prints one log line for the given case.
    #
    # + case - name of the case, for example `quote`
    # + return - what was printed, or 404 for an unknown case
    resource function get [string case]() returns json|http:NotFound {
        [boolean, map<json>]? c = cases[case];
        if c is () {
            http:NotFound notFound = {body: {message: string `unknown case '${case}'`, cases: cases.keys()}};
            return notFound;
        }
        string line = printLogLine(case, c[1]);
        json result = {case, expectedToShowEmptyContext: c[0], printed: line};
        return result;
    }

    # Prints one log line for every case.
    #
    # + return - what was printed for each case
    resource function get all() returns json {
        json[] printed = [];
        foreach [string, [boolean, map<json>]] [case, c] in cases.entries() {
            printed.push({case, expectedToShowEmptyContext: c[0], printed: printLogLine(case, c[1])});
        }
        return printed;
    }
}

# Builds a valid single-line JSON log entry and prints it to stdout.
#
# + case - name of the case, used in the log message
# + context - fields added to the log entry next to the message
# + return - the printed line
function printLogLine(string case, map<json> context) returns string {
    map<json> entry = {
        "time": time:utcToString(time:utcNow()),
        "level": "ERROR",
        "module": "logcontext_quote_repro",
        "message": string `LogContext repro: ${case}`
    };
    foreach [string, json] [k, v] in context.entries() {
        entry[k] = v;
    }
    string line = entry.toJsonString();
    io:println(line);
    return line;
}
