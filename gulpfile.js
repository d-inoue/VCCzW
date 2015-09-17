var gulp          = require("gulp");
var browserSync   = require('browser-sync').create();
var reload        = browserSync.reload;

var source        = "www/wordpress/**/*";

gulp.task('browser-sync', function() {
  browserSync.init({
    proxy: "192.168.33.12"
  });
});

gulp.task("watch", function () {
    gulp.watch(source, reload);
});

gulp.task("default", ["browser-sync", "watch"]);