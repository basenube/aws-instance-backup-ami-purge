
![gaze](https://www.basenube.com/img/basenube.png)


## Usage
Install the module with: `npm install gaze` or place into your `package.json`
and run `npm install`.

```javascript
var gaze = require('gaze');

// Watch all .js files/dirs in process.cwd()
gaze('**/*.js', function(err, watcher) {
  // Files have all started watching
  // watcher === this
```

## Documentation

### gaze([patterns, options, callback])

* `patterns` {`String`|`Array`} File patterns to be matched
* `options` {`Object`}
* `callback` {`Function`}
  * `err` {`Error` | `null`}
  * `watcher` {`Object`} Instance of the `Gaze` watcher

### Class: `gaze.Gaze`

Create a `Gaze` object by instancing the `gaze.Gaze` class.

```javascript
var Gaze = require('gaze').Gaze;
var gaze = new Gaze(pattern, options, callback);
```

#### Properties

* `options` The options object passed in.
  * `interval` {integer} Interval to pass to `fs.watchFile`
  * `debounceDelay` {integer} Delay for events called in succession for the same
    file/event in milliseconds
  * `mode` {string} Force the watch mode. Either `'auto'` (default), `'watch'` (force native events), or `'poll'` (force stat polling).
  * `cwd` {string} The current working directory to base file patterns from. Default is `process.cwd()`.

#### Events

* `ready(watcher)` When files have been globbed and watching has begun.
* `all(event, filepath)` When an `added`, `changed`, `renamed`, or `deleted` event occurs.
* `added(filepath)` When a file has been added to a watch directory.
* `changed(filepath)` When a file has been changed.
* `deleted(filepath)` When a file has been deleted.
* `renamed(newPath, oldPath)` When a file has been renamed.
* `end()` When the watcher is closed and watches have been removed.
* `error(err)` When an error occurs.
* `nomatch` When no files have been matched.

#### Methods

* `emit(event, [...])` Wrapper for `EventEmitter.emit`.
  `added`|`changed`|`renamed`|`deleted` events will also trigger the `all` event.
* `close()` Unwatch all files and reset the watch instance.
* `add(patterns, callback)` Adds file(s) `patterns` to be watched.
* `remove(filepath)` Removes a file or directory from being watched. Does not
  recurse directories.
* `watched()` Returns the currently watched files.
* `relative([dir, unixify])` Returns the currently watched files with relative paths.
  * `dir` {string} Only return relative files for this directory.
  * `unixify` {boolean} Return paths with `/` instead of `\\` if on Windows.
## Release History
* 0.1.1 - Minor fixes
* 0.1.0 - Initial release

## Credits
Pretty much stole the pair of python scripts from:

* [paulmillr's `chokidar`](https://github.com/paulmillr/chokidar)
* [amasad's `sane`](https://github.com/amasad/sane)

## License
Copyright (c) 2018 Ronnie Jay Sweeney 
Licensed under the MIT license.
