import resolve from 'rollup-plugin-node-resolve';
import uglify from 'rollup-plugin-uglify';
import commonjs from 'rollup-plugin-commonjs';

export default {
  entry: 'lib/es6/src/snabbdom_demo.js',
  moduleName: 'bs_snabbdom',
  format: 'iife',
  plugins: [ resolve(), commonjs() ],
  dest: 'dist/main.bundle.js'
};
