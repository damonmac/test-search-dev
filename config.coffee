# local configs
exports.chrome = {desiredCapabilities: {browserName: 'chrome'}}

# saucelabs configs
exports.sauceie9 = 
  desiredCapabilities: 
    browserName: 'internet explorer'
    version: '9'
    platform: 'Windows 7'
  host: 'ondemand.saucelabs.com'
  user: process.env.SAUCE_USERNAME
  key: process.env.SAUCE_ACCESS_KEY
  port: 80

exports.sauceie10 = 
  desiredCapabilities: 
    browserName: 'internet explorer'
    version: '10'
    platform: 'Windows 8'
    "screen-resolution": "1280x1024"
    # "device-orientation": "landscape"
  host: 'ondemand.saucelabs.com'
  user: process.env.SAUCE_USERNAME
  key: process.env.SAUCE_ACCESS_KEY
  port: 80

exports.saucechromemac =
  desiredCapabilities:
    browserName: 'chrome'
    platform: 'OS X 10.8'
    "screen-resolution": "1024x768"
  host: 'ondemand.saucelabs.com'
  user: process.env.SAUCE_USERNAME
  key: process.env.SAUCE_ACCESS_KEY
  port: 80