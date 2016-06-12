import { spawn, execSync } from 'child_process';
import path from 'path';
import { expect } from 'chai';

const LEXER = path.join(__dirname, '../build/JabaleLexer');

function match(target, input, expectedOutput, done) {
  const p = spawn(`${target}`);
  let actualOutput = '';
  p.stdout.on('data', (data) => { actualOutput += data; });
  p.on('close', () => {
    expect(actualOutput)
      .to.equal(expectedOutput);
    done();
  });
  p.stdin.end(input);
}

const lexerMatch = match.bind(this, LEXER);

before('Build', (done) => {
  // start from project root dir
  process.chdir('build');
  execSync('cmake ../src/', { stdio: 'inherit' });
  execSync('make', { stdio: 'inherit' });
  process.chdir('../');
  done();
});

describe('Lexer', () => {
  describe('0x101 COMMENT', () => {
    ['// Karada wa tsurugi dekiteiru',
    '/* I am the bone of my sword. */',
    '/* Steel is my body \n and fire is my blood */'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x101 COMMENT\n`, done);
      });
    });
  });

  describe('0x102 BLANK', () => {
    ['\n', ' '].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x102 BLANK\n`, done);
      });
    });
  });

  describe('0x103 KEYWORD', () => {
    ['abstract', 'boolean', 'break', 'byte',
    'case', 'catch', 'char', 'class',
    'const', 'continue', 'default', 'do',
    'double', 'else', 'extends',
    'final', 'finally', 'float', 'for',
    'goto', 'if', 'implements', 'import',
    'instanceof', 'int', 'interface', 'long',
    'native', 'new', 'null', 'package',
    'private', 'protected', 'public', 'return',
    'short', 'static', 'super', 'switch',
    'synchronized', 'this', 'throw', 'throws',
    'transient', 'try', 'void',
    'volatile', 'while'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x103 KEYWORD ${k}\n`, done);
      });
    });
  });

  describe('0x105 BOOL', () => {
    ['true', 'false'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x105 BOOL ${k}\n`, done);
      });
    });
  });

  describe('0x106 CHAR', () => {
    ["'z'", "','", "'\\2'", "'\\23'", "'\\233'",
    "'\\u1'", "'\\u1a'", "'\\u1ae'", "'\\u1aef'",
    "'\\''", "'\\r'", "'\\n'", "'\\f'",
    "'\\t'", "'\\b'"].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x106 CHAR ${k}\n`, done);
      });
    });
  });

  describe('0x107 INT', () => {
    ['123456789', '123456789L',
    '-789', '-789L',
    '0x789L', '-0x789L'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x107 INT ${k}\n`, done);
      });
    });
  });

  describe('0x108 FLOAT', () => {
    ['1.23', '0.123', '.123', '123.',
    '123.0', '123e3', '123E3', '12.3F', '12.3f'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x108 FLOAT ${k}\n`, done);
      });
    });
  });

  describe('0x109 STRING', () => {
    ['""', '"a"', '"\\2"', '"\\23"', '"\\233"',
    '"\\u1"', '"\\u1a"', '"\\u1ae"', '"\\u1aef"',
    '"\\\'"', '"\\r"', '"\\n"', '"\\f"',
    '"\\t"', '"\\b"'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x109 STRING ${k}\n`, done);
      });
    });
  });
});
