# Static Web App - Protected Path Sample

A minimal static web application (served by nginx) with two pages:

| Path            | Access    | Content                          |
|-----------------|-----------|----------------------------------|
| `/index.html`   | Public    | `Public home page`               |
| `/secret.html`  | Protected | `SECRET-PROTECTED`               |

Unlike a single-page app (which serves one `index.html` for every route and
enforces access in the browser), this sample serves a **distinct file per path
from the backend**. That makes it useful for validating that Choreo Managed
Authentication **Protected Paths** actually gate a real server-side resource:
`/secret.html` should only be reachable after logging in.

## Prerequisites

1. Fork the repository.

## Deploy

Follow [Develop a Web Application with Buildpacks](https://wso2.com/choreo/docs/developer/develop-components/deploy-an-application-with-buildpacks/).

1. Select the `Web Application` card in the Component Creation Wizard.
2. Select `Dockerfile` as the buildpack and fill in:

   | Field                       | Value                                  |
   |-----------------------------|----------------------------------------|
   | Name                        | Static Web App Protected Path          |
   | Description                 | Static web app with a protected page   |
   | GitHub Account              | Your account                           |
   | GitHub Repository           | wso2-choreo-samples                    |
   | Branch                      | `static-webapp-protected-path-sample`  |
   | Buildpack                   | Dockerfile                             |
   | Project Directory           | `static-webapp-protected-path`         |
   | Dockerfile                  | `static-webapp-protected-path/Dockerfile` |
   | Port                        | `8080`                                 |

3. Click **Create**, then open the component.

## Enable Managed Authentication with a protected path

In the deploy configuration, under **Authentication**:

1. Enable **Managed Authentication**.
2. Set:

   | Field           | Value            |
   |-----------------|------------------|
   | Post Login Path | `/`              |
   | Protected Paths | `/secret.html`   |

3. Deploy.

## Verify

With no active session (e.g. a fresh private browser window, or `curl` without cookies):

- `GET /index.html` -> `200`, shows `Public home page`.
- `GET /secret.html` -> **redirect to the login page** (the protected-path gate).

After logging in:

- `GET /secret.html` -> `200`, shows `SECRET-PROTECTED`.

If `/secret.html` returns its content **without** first redirecting you to log in,
the protected-path check did not gate the request.
