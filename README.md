## Search Acceptance Testing

### Introduction

[Mocha](http://visionmedia.github.io/mocha/) is a fun way to manage and organize your tests.  There are two types of test examples here - webdriverjs driven and direct http requests (to test the api).  The webdriver tests can run locally with the selenium standalone jar running, or they can run on [saucelabs](https://saucelabs.com) by changing the remote webdriver configuration.  In the end, functionality tests across many browser/os combinations is expected.

### Getting started

We expect to run the tests in Saucelabs usually, but if you want to develop them locally first you need to [download the selenium standalone jar](https://selenium.googlecode.com/files/selenium-server-standalone-2.35.0.jar).  To startup the standalone selenium server on default port 4444 run:

     $ java -jar Downloads/selenium-server-standalone-2.35.0.jar

#### Configuration

To run the tests in Saucelabs you must setup these environment variables:

     $ SAUCE_USERNAME=<your sauce user>
     $ SAUCE_ACCESS_KEY=<your sauce key>
     $ SAUCE_CONFIG=<choose exported config name, i.e. 'sauceie9'>
     
### Running the tests

You need to have [node](http://nodejs.org/) and [npm](https://npmjs.org/) installed.  Please install mocha globally if you are planning to develop:

     $ npm install mocha -g

To install the test modules and run the tests:

     $ npm install
     $ npm test

To manually run one test file:

     $ mocha examples/browsers.coffee

To manually run one test within a file and watch for changes to the file:

     $ mocha -w --grep 'Record Search'
