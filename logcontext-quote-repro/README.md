# LogContext quote repro

A minimal Ballerina service for reproducing a Runtime Logs bug: when a JSON log line has a context value containing a double quote (`"`), a newline or a backslash, Observability > Runtime Logs shows the context as `{}` and the exported logs lose it. The log message itself shows correctly.

Each endpoint prints one valid single-line JSON log entry to stdout and returns what it printed.

| Endpoint | Context contains | Runtime Logs today |
|---|---|---|
| `GET /repro/quote` | `"server-timing":["t;desc=\"abc\", sem_wait;dur=0"]` (the reported case) | `{}` |
| `GET /repro/newline` | a multi-line `stackTrace` string | `{}` |
| `GET /repro/backslash` | a Windows path | `{}` |
| `GET /repro/no-quote` | the same headers without quotes | shown |
| `GET /repro/nested` | a nested object with an array | shown |
| `GET /repro/all` | all of the above | |

## How to reproduce in Choreo

1. Create a Ballerina service component with `logcontext-quote-repro` as the component directory.
2. Build and deploy it, then call `GET /repro/all` (or one case at a time).
3. Open Observability > Runtime Logs for the component and look at the `LogContext repro: <case>` entries. The `quote`, `newline` and `backslash` entries show `{}` after the message, while `no-quote` and `nested` show their context.
4. In the browser's Network tab, open the `.../logs/component/application` response. For the failing cases the `LogContext` string has unescaped quotes or raw line breaks, so it is not valid JSON.
5. Export the logs. The failing cases have `{}` instead of their context.

After the fix, all five cases show their full context.
