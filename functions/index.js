const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// aiProxy: verifies optional Firebase ID token and forwards prompt to OpenAI
exports.aiProxy = functions.https.onRequest(async (req, res) => {
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  try {
    const authHeader = req.get('Authorization') || '';
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const idToken = authHeader.split('Bearer ')[1];
      // verify token; throws if invalid
      await admin.auth().verifyIdToken(idToken);
    }

    const body = req.body || {};
    const prompt = body.prompt || '';
    if (!prompt) {
      res.status(400).json({ error: 'Missing prompt in request body.' });
      return;
    }

    const openaiKey = functions.config().openai && functions.config().openai.key;
    if (!openaiKey) {
      res.status(500).json({ error: 'OpenAI key not configured. Use `firebase functions:config:set openai.key="YOUR_KEY"`' });
      return;
    }

    const fetch = globalThis.fetch || require('node-fetch');

    // Forward to OpenAI Chat Completions (adjust model as needed)
    const openaiResp = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${openaiKey}`,
      },
      body: JSON.stringify({ model: 'gpt-4o-mini', messages: [{ role: 'user', content: prompt }], max_tokens: 512 }),
    });

    const json = await openaiResp.json();
    let text = '';
    if (json.choices && json.choices[0] && json.choices[0].message) {
      text = json.choices[0].message.content || '';
    } else if (json.choices && json.choices[0] && json.choices[0].text) {
      text = json.choices[0].text || '';
    }

    res.json({ response: text, raw: json });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message || String(err) });
  }
});
