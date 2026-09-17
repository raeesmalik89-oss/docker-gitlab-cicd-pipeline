const test = require('node:test');
const assert = require('node:assert');
const app = require('../app');

let server;
let baseUrl;

test.before(() => new Promise((resolve) => {
    server = app.listen(0, () => {
        baseUrl = `http://127.0.0.1:${server.address().port}`;
        resolve();
    });
}));

test.after(() => new Promise((resolve) => server.close(resolve)));

test('GET /health returns healthy', async () => {
    const res = await fetch(`${baseUrl}/health`);
    assert.strictEqual(res.status, 200);
    assert.deepStrictEqual(await res.json(), { status: 'healthy' });
});

test('GET / returns app info', async () => {
    const res = await fetch(`${baseUrl}/`);
    const body = await res.json();
    assert.strictEqual(res.status, 200);
    assert.ok(body.message.includes('Docker CI/CD'));
    assert.ok(body.version);
});
