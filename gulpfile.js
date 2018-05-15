require('dotenv').load();

const gulp = require('gulp');
const nodemon = require('nodemon');
const browserify = require('browserify');
const babelify = require('babelify');
const uglify = require('gulp-uglify');
const stylus = require('gulp-stylus');
const autoprefixer = require('gulp-autoprefixer');
const cleanCSS = require('gulp-clean-css');
const sourcemaps = require('gulp-sourcemaps');
const concat = require('gulp-concat');
// const imagemin = require('gulp-imagemin');
// const imageminMozjpeg = require('imagemin-mozjpeg');
const rev = require('gulp-rev');
const revFormat = require('gulp-rev-format');
const livereload = require('gulp-refresh');
const gif = require('gulp-if');
const clean = require('gulp-clean');
const plumber = require('gulp-plumber');
const rename = require('gulp-rename');

const sequence = require('run-sequence');
const source = require('vinyl-source-stream');
const buffer = require('vinyl-buffer');
const path = require('path');
const nib = require('nib');

const config = {
	debug: 		 process.env.ASSET_DEBUG || false,
	compression: process.env.ASSET_COMPRESSION || true,
	sourcemap: 	 process.env.ASSET_SOURCEMAP || false,
	dir: {
		build: 	 path.join(__dirname, 'public/build/'),
		styles:  path.join(__dirname, 'resources/assets/'),
		scripts: path.join(__dirname, 'resources/assets/'),
		images:  path.join(__dirname, 'public/img/'),
		server:  path.join(__dirname, 'src/'),
	},
};

gulp.task('scripts', function() {
	return browserify({entries: config.dir.scripts + 'main.js', debug: config.debug })
		// .transform('babelify', { presets: ['es2015'] })
		.bundle()
		// .pipe(gulp.src(config.dir.scripts + 'main.js', { read: false }))
		.pipe(source('main.js'))
		.pipe(buffer())
		.pipe(gif(config.compression, uglify()))
		.pipe(gulp.dest(config.dir.build));
});

gulp.task('styles', function() {
	return gulp.src(config.dir.styles + 'main.styl')
		.pipe(plumber())
		.pipe(gif(config.sourcemap, sourcemaps.init()))
		.pipe(stylus({
			compress: true,
			'include css': true,
			use: [
				nib(),
			],
			import: ['nib'],
		}))
		.pipe(autoprefixer('last 2 version'))
		.pipe(gif(config.compression, cleanCSS({compatibility: 'ie9'})))
		.pipe(gif(config.sourcemap, sourcemaps.write()))
		.pipe(gulp.dest(config.dir.build));
});

// gulp.task('images', function () {
// 	return gulp.src(config.dir.images + '**/*.jpg')
// 		.pipe(imagemin([
// 			imageminMozjpeg({
//         		quality: 85,
//         		progressive: true,
//     		})
//     	]))
// 		.pipe(gulp.dest(config.dir.images));
// });

gulp.task('rev-clean', function() {
	return gulp.src([config.dir.build + '*.rev.*']).pipe(clean());
});

gulp.task('rev', ['rev-clean'], function() {
	gulp.src([config.dir.build + '*.css', config.dir.build + '*.js'])
		.pipe(rev())
		.pipe(revFormat({
			prefix: '-',
			suffix: '.rev',
			lastExt: false,
		}))
		.pipe(gulp.dest(config.dir.build))  // write rev'd assets to build dir
		.pipe(rev.manifest())
		.pipe(gulp.dest(config.dir.build))  // write manifest to build dir
		.pipe(livereload());
});

gulp.task('watch', function() {
	livereload.listen();

	gulp.watch(config.dir.scripts + '/**/*.js',  () => sequence('scripts', 'rev'));
	gulp.watch(config.dir.styles + '/**/*.styl', () => sequence('styles', 'rev'));

	nodemon({
		script: './bin/www',
		ignore: config.dir.build + '*.js',
		ext: 'js json pug',
		watch: [
			config.dir.server + '**/*.js',
		]
	})
	.on('restart', function() {
		setTimeout(function () {
			livereload.reload();
		}, 500);
	});
});

gulp.task('default', function() {
	sequence(['scripts', 'styles'], 'rev');
});
