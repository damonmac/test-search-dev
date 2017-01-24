## Search Acceptance Testing

### Introduction

[Mocha](http://mochajs.org/) is a fun way to organize and run your tests.  We are using [webdriverjs](https://github.com/camme/webdriverjs/blob/master/README.md) to drive front-end automation tests.  The tests can run locally with the selenium standalone jar running, or they can run on [saucelabs](https://saucelabs.com) by changing the configuration.

### Getting started

We expect to run the tests in Saucelabs usually, but if you want to develop them locally first you need to [download the selenium standalone jar](https://selenium.googlecode.com/files/selenium-server-standalone-2.35.0.jar).  To startup the standalone selenium server on default port 4444 run:

     $ java -jar Downloads/selenium-server-standalone-2.35.0.jar

Note: you need to [follow the ChromeDriver installation](http://code.google.com/p/selenium/wiki/ChromeDriver) instructions if you want to run in chrome locally as well.

#### Configuration

To run the tests in Saucelabs you must setup (or export) these environment variables:

     $ SAUCE_USERNAME=<your sauce user>
     $ SAUCE_ACCESS_KEY=<your sauce key>
     $ SAUCE_CONFIG=<choose exported config name, i.e. 'sauceie9'>
     
You need to have [node](http://nodejs.org/) and [npm](https://npmjs.org/) installed.  Please install mocha globally if you are planning to develop:

     $ npm install mocha -g

### Running the tests

To install the test modules and run the tests:

     $ npm install
     $ npm test

To manually run one test file:

     $ mocha examples/browsers.coffee

To manually run one test within a file and watch for changes to the file:

     $ mocha -w --grep 'Record Search'
