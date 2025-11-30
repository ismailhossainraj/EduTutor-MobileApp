AI Proxy (Firebase Functions) — scaffold and deployment
=====================================================

Overview
--------
This app uses a server-side AI proxy to avoid embedding provider API keys in the mobile client.
Below are step-by-step instructions to deploy the proxy as Firebase Functions and configure the Flutter app.

1) Prepare Firebase Functions
--------------------------------
- Install Firebase CLI: `npm i -g firebase-tools` and login with your Google (edu) account:

  ```powershell
  firebase login --reauth
  ```

- Initialize functions in this repo (run in project root):

  ```powershell
  firebase init functions
  ```

- When asked choose Node 18 and TypeScript or JavaScript. Copy the file `tools/ai_proxy/index.js` into the newly created `functions/index.js` (overwrite the template), and ensure `package.json` has `firebase-functions` and `firebase-admin` dependencies.

2) Configure your OpenAI (or other) API key
-------------------------------------------
- Set the key in Functions config (do NOT commit the key):

  ```powershell
  firebase functions:config:set openai.key="YOUR_OPENAI_API_KEY"
  ```

3) Deploy the function
----------------------

  ```powershell
  firebase deploy --only functions:aiProxy
  ```

  After deploy you'll get a URL like:

  `https://us-central1-YOUR_PROJECT.cloudfunctions.net/aiProxy`

4) Configure the Flutter app
----------------------------
- Use a compile-time define so you don't store the endpoint in source control. Run the app with:

  ```powershell
  flutter run --dart-define=AI_PROXY_URL="https://us-central1-YOUR_PROJECT.cloudfunctions.net/aiProxy"
  ```

- The client attaches the current Firebase ID token as an Authorization header when available. The server verifies that token before forwarding requests.

5) Test the chat UI
--------------------
- Open the app (signed in) and use the AI chat. If you see an error that mentions `YOUR_AI_PROXY_ENDPOINT`, it means you need to set `AI_PROXY_URL` as above.

Security notes
--------------
- Never embed provider API keys in the mobile client. Use server-side environment/config.
- The proxy code included performs basic Firebase ID token verification. You can add rate-limiting, usage logging, and content filtering server-side.

If you'd like, I can (a) generate a complete `functions/` folder and `package.json` for you, (b) produce CLI commands to deploy using your edu account, or (c) create a small local proxy for testing without deploying.
