chai = require 'chai'
assert = chai.assert
webdriverjs = require 'webdriverjs'

describeTestBrowsers = (testFun) ->

  describe 'Saucelabs Firefox', ->
    testFun.call this,
      desiredCapabilities:
        browserName: 'firefox'
        platform: 'Windows 7'
        "screen-resolution": "1280x1024"
        tags: ['firefox']
        name: 'Windows 7 Firefox'        
      host: 'ondemand.saucelabs.com'
      user: process.env.SAUCE_USERNAME
      key: process.env.SAUCE_ACCESS_KEY
      port: 80

  describe 'Saucelabs IE 10', ->
    testFun.call this,
      desiredCapabilities:
        browserName: 'internet explorer'
        version: '10'
        platform: 'Windows 7'
        "screen-resolution": "1280x1024"
        tags: ['explorer']
        name: 'Windows 7 IE 10'        
      host: 'ondemand.saucelabs.com'
      user: process.env.SAUCE_USERNAME
      key: process.env.SAUCE_ACCESS_KEY
      port: 80


describeTestBrowsers (desired) ->
  this.timeout 180000
  client = {}
  root = 'https://familysearch.org/search'

  before ->
    client = webdriverjs.remote(desired).init()
    .windowHandleSize({width: 1280, height: 900}, (err) ->
      assert.isNull err, "Problem resizing initial browser window"
    )

  after (done) ->
    client.end done

  describe "Header", ->
    it 'checks search page title and footer links', (done) ->
      client
      .url(root)
      .isVisible("a#sign-in", (err, result) ->
        assert.isNull err, "Link not showing"
      )
      .getTitle((err, title) ->
        assert.isNull err, "Error getting title"
        assert.include title, 'Explore Billions of Historical Records'
      )
      .call(done)      

  describe 'Browse a collection', ->
    it 'browses Alabama County Marriages by collection', (done) ->
      client
      .url(root + '/collection/list')
      .getTitle((err, title) ->
        assert.isNull err, "Error getting all collections title"
        assert.strictEqual title, 'All Published Record Collections — FamilySearch.org'
      )
      .waitFor('a[href="/search/collection/1743384"]', 8000, (err, result) ->
        assert.isNull err, "Error displaying collections"
      )
      .click('a[href="/search/collection/1743384"]', (err, result) ->
        assert.isNull err, "Error clicking on a collection"
      )
      .waitFor("input[name=givenname]", 8000, (err, result) ->
        assert.isNull err, "Error rendering the search dialog"
      )
      .getTitle((err, title) ->
        assert.isNull err, "Error showing collection title"
        assert.include title, 'Alabama, County Marriages'
      )
      .call(done)


