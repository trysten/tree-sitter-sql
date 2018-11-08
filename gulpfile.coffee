gulp = require 'gulp'
coffee = require 'gulp-coffee'
c = require 'ansi-colors'
log = require 'fancy-log'
exec = require('child_process').exec
del = require 'del'

gulp.task 'js', () ->
    console.log("hi, doing js")

gulp.task 'default', () ->
    gulp.watch 'grammar.coffee', ['coffee']
    gulp.watch 'grammar.js', ['tree-sitter-generate']

gulp.task 'clean', () ->
    gulp.src(['./src'
              './build'])
        .pipe(del())

gulp.task 'coffee', () ->
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

gulp.task 'tree-sitter-generate', (cb) ->
    exec 'tree-sitter generate', (err) ->
        if err
            log(err.message)
    exec 'node-gyp rebuild', (err) ->
        cb()
