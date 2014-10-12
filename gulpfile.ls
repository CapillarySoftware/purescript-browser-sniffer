require! <[
  express 
  run-sequence 
  js-string-escape
  gulp 
  gulp-if 
  gulp-karma
  gulp-concat 
  gulp-rename
  gulp-purescript 
  gulp-filter
  gulp-file-include
]>

paths =
  test:
    src: <[
      bower_components/chai/chai.js
      bower_components/purescript-*/src/**/*.purs
      bower_components/purescript-*/src/**/*.purs.hs
      src/**/*.purs
    ]>
    dest: "tmp"

options =
  prod:
    output: "App.js"
    main: true

  test:
    output: "Test.js"
    main: true
    externs: "extern.purs"

port   = 3333
server = express()

fil = gulp-filter (file) -> not /Test/ig.test file.path 

build = (k) -> ->
  x   = paths[k]
  o   = options[k]
  psc = gulp-purescript.psc o

  psc.on "error" ({message}) ->
    console.error message
    psc.end()

  gulp.src x.src 
    .pipe gulp-if /.purs/, psc
    .pipe gulp-concat o.output
    .pipe gulp.dest x.dest

gulp.task "build:test", build "test"
gulp.task "test:unit" ->
  gulp.src options.test.output .pipe gulp-karma(
    configFile : "./karma.conf.ls"
    noColors   : true
    action     : "run"
  )

gulp.task "doc" ->
  gulp.src "src/**/*.purs"
    .pipe fil 
    .pipe gulp-purescript.docgen()
    .pipe gulp.dest "DocGen.md"

gulp.task "build"   <[build:prod build:html]>
gulp.task "default" <[build watch serve]>
gulp.task "test" -> run-sequence "build:test" "test:unit"
gulp.task "travis"  <[build test]>
