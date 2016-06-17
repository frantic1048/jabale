import { spawn, execSync } from 'child_process';
import path from 'path';
import { expect } from 'chai';

const LEXER = path.join(__dirname, '../build/Lexer');

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
  describe('0x100 BADTOKEN', () => {
    ['@', '`', '#'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x100 BADTOKEN at line:1 ${k}\n`, done);
      });
    });
  });

  describe('0x101 COMMENT', () => {
    ['// Karada wa tsurugi dekiteiru',
    '/* I am the bone of my sword. */',
    '/* Steel is my body \n and fire is my blood */'].forEach(k => {
      it(`${k.replace('\n', '\\n')}`, (done) => {
        lexerMatch(k, `0x101 COMMENT\n`, done);
      });
    });
  });

  describe('0x102 BLANK', () => {
    ['\n', ' '].forEach(k => {
      it(`${k.replace('\n', '\\n')}`, (done) => {
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

  describe('0x104 IDENTIFIER', () => {
    ['$', '_', 'a',
    '$-', '$_', '$a', '$$',
    '_z', '_$', '__', '_-',
    'a-', 'a_', 'az'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x104 IDENTIFIER ${k}\n`, done);
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

  describe('0x110 ASSIGN', () => {
    ['=', '+=', '-=', '*=', '/=', '%=',
    '&=', '^=', '|=',
    '>>=', '<<=', '>>>='].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x110 ASSIGN ${k}\n`, done);
      });
    });
  });

  describe('0x111 COND', () => {
    ['?', ':'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x111 COND ${k}\n`, done);
      });
    });
  });

  describe('0x112 BOOLOR', () => {
    ['||'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x112 BOOLOR ${k}\n`, done);
      });
    });
  });

  describe('0x113 BOOLAND', () => {
    ['&&'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x113 BOOLAND ${k}\n`, done);
      });
    });
  });

  describe('0x114 BITOR', () => {
    ['|'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x114 BITOR ${k}\n`, done);
      });
    });
  });

  describe('0x115 BITXOR', () => {
    ['^'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x115 BITXOR ${k}\n`, done);
      });
    });
  });

  describe('0x116 BITAND', () => {
    ['&'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x116 BITAND ${k}\n`, done);
      });
    });
  });

  describe('0x117 EQUAL', () => {
    ['==', '!='].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x117 EQUAL ${k}\n`, done);
      });
    });
  });

  describe('0x118 ORDER', () => {
    ['<', '>', '<=', '>='].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x118 ORDER ${k}\n`, done);
      });
    });
  });

  describe('0x119 BITSHIFT', () => {
    ['<<', '>>', '>>>'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x119 BITSHIFT ${k}\n`, done);
      });
    });
  });

  describe('0x11a ARITH1', () => {
    ['+', '-'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x11a ARITH1 ${k}\n`, done);
      });
    });
  });

  describe('0x11b ARITH2', () => {
    ['*', '/', '%'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x11b ARITH2 ${k}\n`, done);
      });
    });
  });

  describe('0x11c MONOARG', () => {
    ['++', '--',
    '!', '~'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x11c MONOARG ${k}\n`, done);
      });
    });
    // TODO: Test "+" "-"
  });

  describe('0x11d EDGE', () => {
    ['(', ')', '[', ']', '.'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x11d EDGE ${k}\n`, done);
      });
    });
  });

  describe('0x120 COMMA', () => {
    [','].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x120 COMMA ${k}\n`, done);
      });
    });
  });

  describe('0x121 BRACE', () => {
    ['{', '}'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x121 BRACE ${k}\n`, done);
      });
    });
  });

  describe('0x122 SEMICOLON', () => {
    [';'].forEach(k => {
      it(`${k}`, (done) => {
        lexerMatch(k, `0x122 SEMICOLON ${k}\n`, done);
      });
    });
  });
});
