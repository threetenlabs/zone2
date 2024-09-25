// Copyright 2012 Google LLC
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

"use strict";

const fs = require("fs");
const path = require("path");
const http = require("http");
const url = require("url");
const opn = require("open");
const destroyer = require("server-destroy");

const { google } = require("googleapis");
const fbAppDistribution = google.firebaseappdistribution("v1");

/**
 * To use OAuth2 authentication, we need access to a CLIENT_ID, CLIENT_SECRET, AND REDIRECT_URI.  To get these credentials for your application, visit https://console.cloud.google.com/apis/credentials.
 */
const keyPath = path.join(__dirname, "oauth2.keys.json");
let keys = { redirect_uris: [""] };
if (fs.existsSync(keyPath)) {
  keys = require(keyPath).web;
}

/**
 * Create a new OAuth2 client with the configured keys.
 */
const oauth2Client = new google.auth.OAuth2(
  "738312330924-jru8cj5u5b7qit3r53qfftrssjgsb5dn.apps.googleusercontent.com",
  "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",
  "http://localhost:3000/oauth2callback"
);

/**
 * This is one of the many ways you can configure googleapis to use authentication credentials.  In this method, we're setting a global reference for all APIs.  Any other API you use here, like google.drive('v3'), will now use this auth client. You can also override the auth client at the service and method call levels.
 */
google.options({ auth: oauth2Client });

/**
 * Open an http server to accept the oauth callback. In this simple example, the only request to our webserver is to /callback?code=<code>
 */
async function authenticate(scopes) {
  return new Promise((resolve, reject) => {
    // grab the url that will be used for authorization
    const authorizeUrl = oauth2Client.generateAuthUrl({
      access_type: "offline",
      scope: scopes.join(" "),
    });
    const server = http
      .createServer(async (req, res) => {
        try {
          if (req.url.indexOf("/oauth2callback") > -1) {
            const qs = new url.URL(req.url, "http://localhost:3000")
              .searchParams;
            res.end("Authentication successful! Please return to the console.");
            server.destroy();
            const { tokens } = await oauth2Client.getToken(qs.get("code"));
            oauth2Client.credentials = tokens; // eslint-disable-line require-atomic-updates
            resolve(oauth2Client);
          }
        } catch (e) {
          console.error(e); // eslint-disable-line no-console
          reject(e);
        }
      })
      .listen(3000, () => {
        // open the browser to the authorize url to start the workflow
        opn(authorizeUrl, { wait: false }).then((cp) => cp.unref());
      });
    destroyer(server);
  });
}

// async function incrementBuildVersion(project) {
//   // retrieve user profile
//   const res = await fbAppDistribution.projects.apps.releases.list({
//     parent: project,
//     pageSize: 1,
//   });

//   if (res.data.releases) {
//     if (res.data.releases.length > 0) {
//       const release = res.data.releases[0];
//       const currentBuildVersion = release.buildVersion;

//       // Convert the currentBuildVersion to an integer and increment by 1
//       const incrementedBuildVersion = parseInt(currentBuildVersion, 10) + 1;

//       return Promise.resolve(incrementedBuildVersion);
//     }
//   }
// }

async function incrementBuildVersion(project) {
  try {
    // Try to retrieve the latest release
    const res = await fbAppDistribution.projects.apps.releases.list({
      parent: project,
      pageSize: 1,
    });

    if (res.data.releases && res.data.releases.length > 0) {
      const release = res.data.releases[0];
      const currentBuildVersion = release.buildVersion;

      // Convert the currentBuildVersion to an integer and increment by 1
      const incrementedBuildVersion = parseInt(currentBuildVersion, 10) + 1;

      return incrementedBuildVersion;
    } else {
      // No releases found, start with version 1
      return 1;
    }
  } catch (error) {
    // Check if the error is a 404 or another kind of error
    if (error.response && error.response.status === 404) {
      // If it's a 404 error, assume no releases and start with version 1
      return 1;
    } else {
      // If it's any other kind of error, rethrow it
      throw error;
    }
  }
}

const scopes = ["https://www.googleapis.com/auth/cloud-platform", "profile"];

const project = process.argv[2];

// console.log(`Project: ${project}`);
authenticate(scopes)
  .then((client) => incrementBuildVersion(project))
  .then((result) => {
    console.log(result);
    return result;
  })
  .catch((error) => {
    console.error(JSON.stringify(error, null, 2));
    return error;
  });
