import { spawn, execSync } from 'child_process';
import path from 'path';
import { expect } from 'chai';

const PARSER = path.join(__dirname, '../build/Parser');

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

const parserMatch = match.bind(this, PARSER);

before('Build', (done) => {
  // start from project root dir
  process.chdir('build');
  execSync('cmake ../src/', { stdio: 'inherit' });
  execSync('make', { stdio: 'inherit' });
  process.chdir('../');
  done();
});

describe('Parser', () => {
  describe('Assign', () => {
    describe('Const', () => {
      it('a = 2; b = 3;', (done) => {
        const input = 'a = 2; b = 3;';
        const output = '(=,2, ,@t1)\n'
                     + '(=,@t1, ,a)\n'
                     + '(=,3, ,@t2)\n'
                     + '(=,@t2, ,b)\n';
        parserMatch(input, output, done);
      });
    });
    describe('Identifier', () => {
      it('a = 2; b = a;', (done) => {
        const input = 'a = 2; b = a;';
        const output = '(=,2, ,@t1)\n'
                     + '(=,@t1, ,a)\n'
                     + '(=,a, ,@t2)\n'
                     + '(=,@t2, ,b)\n';
        parserMatch(input, output, done);
      });
    });
    describe('Expression', () => {
      it('a = 2 + 3;', (done) => {
        const input = 'a = 2 + 3;';
        const output = '(=,2, ,@t1)\n'
                     + '(=,3, ,@t2)\n'
                     + '(+,@t1,@t2,@t3)\n'
                     + '(=,@t3, ,a)\n';
        parserMatch(input, output, done);
      });
      it('a = 2 + 3 * 4;', (done) => {
        const input = 'a=2 + 3 * 4;';
        const output = '(=,2, ,@t1)\n'
                     + '(=,3, ,@t2)\n'
                     + '(*,@t2,4,@t3)\n'
                     + '(+,@t1,@t3,@t4)\n'
                     + '(=,@t4, ,a)\n';
        parserMatch(input, output, done);
      });
      it('a = 2 - 3 / 4;', (done) => {
        const input = 'a = 2 - 3 / 4;';
        const output = '(=,2, ,@t1)\n'
                     + '(=,3, ,@t2)\n'
                     + '(/,@t2,4,@t3)\n'
                     + '(-,@t1,@t3,@t4)\n'
                     + '(=,@t4, ,a)\n';
        parserMatch(input, output, done);
      });
      it('a = 2; b = a - 3 / 4;', (done) => {
        const input = 'a = 2; b = a - 3 / 4;';
        const output = '(=,2, ,@t1)\n'
                     + '(=,@t1, ,a)\n'
                     + '(=,a, ,@t2)\n'
                     + '(=,3, ,@t3)\n'
                     + '(/,@t3,4,@t4)\n'
                     + '(-,@t2,@t4,@t5)\n'
                     + '(=,@t5, ,b)\n';
        parserMatch(input, output, done);
      });
    });
  });
  describe('While', () => {
    it('while(2 < 3) a = 4;', (done) => {
      const input = 'while(2 < 3) a = 4;';
      const output = '@ws1\n'
                   + '(<,2,3,@t1)\n'
                   + '(jF,@t1,@we1, )\n'
                   + '(=,4, ,@t2)\n'
                   + '(=,@t2, ,a)\n'
                   + '(j,@ws1, , )\n'
                   + '@we1\n';
      parserMatch(input, output, done);
    });
    it('while(2 < 3) a = 4;while(4 > 3) b = 4;', (done) => {
      const input = 'while(2 < 3) a = 4;while(4 > 3) b = 4;';
      const output = '@ws1\n'
                   + '(<,2,3,@t1)\n'
                   + '(jF,@t1,@we1, )\n'
                   + '(=,4, ,@t2)\n'
                   + '(=,@t2, ,a)\n'
                   + '(j,@ws1, , )\n'
                   + '@we1\n'
                   + '@ws2\n'
                   + '(>,4,3,@t3)\n'
                   + '(jF,@t3,@we2, )\n'
                   + '(=,4, ,@t4)\n'
                   + '(=,@t4, ,b)\n'
                   + '(j,@ws2, , )\n'
                   + '@we2\n';
      parserMatch(input, output, done);
    });
  });
});
