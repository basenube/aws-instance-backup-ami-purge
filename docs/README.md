
![gaze](https://www.basenube.com/img/basenube.png)

## Purpose
A complete backup and purge instance solution

## Usage
You can run this from the console as a single stack or through a StackSet to reach multiple accounts (stack set compatible).

Your huckleberry for the CLI is here:

```bash
baseNUBE> aws cloudformation create-stack --stack-name myteststack --template-body file:///basenube-aws-instance-backup-ami-purge-stack.yaml --parameters ParameterKey=Parm1,ParameterValue=test1 ParameterKey=Parm2,ParameterValue=test2

{
  "StackId" : "arn:aws:cloudformation:us-west-2:123456789012:stack/myteststack/330b0120-1771-11e4-af37-50ba1b98bea6"
}

```

## Documentation

### Resource Creation
This stack creates the following AWS Resources:

* Backup Instance Lambda Function
* 
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
