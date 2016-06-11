import { spawn, execSync } from 'child_process';
import path from 'path';
import { expect } from 'chai';

const LEXER = path.join(__dirname, '../build/JabaleLexer');

function match(target, input, expectedOutput, done) {
  const p = spawn(`${target}`);
  let actualOutput = '';
  p.stdout.on('data', (data) => { actualOutput += data; })
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
  it("ONE", (done) => {
    lexerMatch('tooo 233323', '233323\n', done);
  });

  it("TWO", (done) => {
    lexerMatch('2323', '2323\n', done);
  });
});
