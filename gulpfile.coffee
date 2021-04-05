{ src, dest, watch, series } = require 'gulp'
coffee = require 'gulp-coffee'
exec = require('child_process').exec
del = require 'del'
debug = true

clean = () ->
    del(['./src', './build'])

    #why did I have node-gyp rebuild?
    # it doesn't seem useful for tree-sitter > 4.0.0
node_gyp_rebuild = (cb) ->
    exec 'node-gyp rebuild', (err, stdout, stderr) ->
        console.log(stdout)
        console.log(stderr)
        cb(err)

tree_sitter_generate = (cb) ->
    exec 'tree-sitter generate', (err, stdout, stderr) ->
        console.log(stdout)
        console.log(stderr)
        cb(err)

tree_sitter_test = (cb) ->
    exec 'tree-sitter test', (err, stdout, stderr) ->
        console.log(stdout)
        console.log(stderr)
        cb(err)

compile_coffeescript = (cb) ->
    src('grammar.coffee')
        .pipe(coffee())
        .pipe(dest('./', { overwrite: true }))
    cb()


grammar_watch = (cb) ->
    watch('./grammar.coffee', series(compile_coffeescript, tree_sitter_generate, tree_sitter_test))
    #series(compile_coffeescript, tree_sitter_generate, tree_sitter_test)
    cb()

# shouldn't be any need for a cleaning function
clean = (cb) ->
    del(['./build', './bindings', '.src'])
    cb()

exports.generate = tree_sitter_generate
#exports.watch = watch
exports.default = grammar_watch
