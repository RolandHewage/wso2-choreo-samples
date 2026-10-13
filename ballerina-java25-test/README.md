# Ballerina Java 25 test components

Two minimal Ballerina services for checking which Java version Choreo uses for the build, the runtime and the unit tests.

| Component directory | `distribution` in `Ballerina.toml` | Expected Ballerina | Expected Java |
|---|---|---|---|
| `ballerina-java25-test/unpinned` | not set (uses the latest) | 2201.14.x | 25 |
| `ballerina-java25-test/pinned-2201-13` | `2201.13.6` | 2201.13.6 | 21 |

## How to test in Choreo

1. Create a Ballerina service component for each directory (component directory as above).
2. Enable unit tests in the build settings.
3. Build. The build log shows `Detected JRE Version: jdk-25.0.4.1+1` (unpinned) or `jdk-21.0.5+11` (pinned), and the unit test step shows `1 passing`.
4. Deploy and call `GET /greeting?name=Choreo`. The response includes the runtime Java version:

```json
{"message": "Hello, Choreo!", "javaVersion": "25.0.4.1"}
```
