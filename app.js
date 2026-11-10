const express = require('express');
const _ = require('lodash');
const { exec } = require('child_process');

const app = express();
app.use(express.json());

const PORT = process.env.PORT || 3000;

const defaultSettings = { theme: 'light', notifications: true };

// --- Safe routes -----------------------------------------------------------

app.get('/', (req, res) => {
  res.json({ message: 'Secure pipeline demo is running' });
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// --- PLANTED ISSUES (remove or fix these in your remediation PR) ----------

// 1. Reflected XSS: user input is written into HTML without escaping.
//    Expected finding: Semgrep (SAST).
app.get('/hello', (req, res) => {
  const name = req.query.name || 'world';
  res.send('<h1>Hello ' + name + '</h1>');
});

// 2. Command injection: user input is concatenated into a shell command.
//    Expected finding: Semgrep (SAST).
app.get('/echo', (req, res) => {
  const text = req.query.text || '';
  exec('echo ' + text, (err, stdout) => {
    if (err) return res.status(500).send('error');
    res.send(stdout);
  });
});

// 3. Prototype pollution risk: merging untrusted input with a vulnerable
//    lodash version (4.17.15). Expected finding: Snyk (SCA), plus the
//    outdated express 4.17.1 dependency tree.
app.post('/settings', (req, res) => {
  const settings = _.merge({}, defaultSettings, req.body);
  res.json(settings);
});

// ---------------------------------------------------------------------------

app.listen(PORT, () => {
  console.log(`Listening on port ${PORT}`);
});
