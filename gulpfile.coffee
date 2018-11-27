gulp = require 'gulp'
coffee = require 'gulp-coffee'
c = require 'ansi-colors'
log = require 'fancy-log'
exec = require('child_process').exec
del = require 'del'
debug = true
gulp.task 'js', () ->
    console.log("hi, doing js")

gulp.task 'default', ['node-gyp-rebuild'], () ->
    gulp.watch 'grammar.coffee', ['node-gyp-rebuild'], options: debounceDelay: 5000

gulp.task 'clean', () ->
        del(['./src','./build'])

gulp.task 'coffee', ['clean'], () ->
    gulp.src 'grammar.coffee'
        .pipe coffee({bare: true})
        .on 'error', (error) ->
            log(c.red('omg, like, an error'))
            #log(error)
            log(error.message)
            log('in ' + error.filename + ' on line:' + c.red error.location.first_line)
            this.emit('end')
            #show = (m) ->
            #    log c.green "L: " + m.location.lastLine + " C: " + m.lastColumn + " in: " + file.path
        .pipe gulp.dest('./')

gulp.task 'tree-sitter-generate', ['coffee'], (cb) ->
    exec 'tree-sitter generate', (err) ->
        if err
            log(err.message)
        else cb()

gulp.task 'node-gyp-rebuild', ['tree-sitter-generate'], (cb) ->

    exec 'node-gyp rebuild', (err) ->
        if err
            log("node-gyp error")
            log(err.message)
        cb()
