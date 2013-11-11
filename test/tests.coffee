chai = require 'chai'
assert = chai.assert
webdriverjs = require 'webdriverjs'
config = require('../config.coffee')

desiredBrowserOs = process.env.SAUCE_CONFIG

if desiredBrowserOs
  console.log "Running with external config: " + desiredBrowserOs
  desired = config[desiredBrowserOs]
else 
  desired = 
    desiredCapabilities:
      browserName: 'chrome'
      # browserName: 'firefox'
      name: 'Allsite'

test = 
  root: "https://familysearch.org"
  sample: "/pal:/MM9.1.1/VRRR-V6B" # 1940 Bob Jones in Idaho between 1900 and 2000

input =
  given: "input[name=givenname]"
  surname: "input[name=surname]"
  birthplace: "input[name=birth_place]"
  birthfrom: "input[name=birth_year_from]"
  birthto: "input[name=birth_year_to]"

link = 
  tree: '#link-record-to-tree'
  image: 'div.image-permissions a'
  signIn: "a#sign-in"
  logo: "a.logo"
  help: "li.help a"
  about: "footer div nav a:nth-of-type(1)"
  blog: "footer div nav a:nth-of-type(2)"
  firstWaypoint: "div#waypoint div#nav.searchExpander ul.waypointBreadCrumbs li a"
  samplecss: 'a[href="' + test.root + test.sample + '"]'
  

describe 'Familysearch', ->
  this.timeout 600000 # overall test timeout
  client = {}

  before ->
    client = webdriverjs.remote(desired)
    .init()
    .windowHandleSize({width: 1280, height: 900}, (err) ->
      assert.isNull err, "Problem resizing initial browser window"
    )

  after (done) ->
    client.end done


  describe "Header", ->
    it 'checks search page title and footer links', (done) ->
      # this.timeout 8000 # individual test timeout: saucelabs compatibility issue?
      client
      .url(test.root + '/search')
      .isVisible(link.logo, (err, result) ->
        assert.isNull err, "logo not showing"
      )
      .isVisible(link.signIn, (err, result) ->
        assert.isNull err, "Link not showing"
      )
      .isVisible(link.help, (err, result) ->
        assert.isNull err, "Link not showing"
      )
      .isVisible(link.about, (err, result) ->
        assert.isNull err, "Link not showing"
      )
      .isVisible(link.blog, (err, result) ->
        assert.isNull err, "Link not showing"
      )
      .getTitle((err, title) ->
        assert.isNull err, "Error getting title"
        assert.include title, 'Explore Billions of Historical Records'
      )
      .call(done)


  describe 'Record Search', ->
    it 'does an initial record search with given and surname', (done) ->
      client
      .url(test.root + '/search')
      .waitFor(input.given, 8000, (err, result) ->
        assert.isNull err, "Expected search form not present"
      )
      .addValue(input.given, "Bob", (err, result) ->
        assert.isNull err, "Error entering query data"
      )
      .addValue(input.surname, "Jones", (err, result) ->
        assert.isNull err, "Error entering query data"
      )
      .addValue(input.birthplace, "Idaho", (err, result) ->
        assert.isNull err, "Error entering query data"
      )
      .addValue(input.birthfrom, "1900", (err, result) ->
        assert.isNull err, "Error entering query data"
      )
      .addValue(input.birthto, '2000', (err, result) ->
        assert.isNull err, "Error entering query data"
      )
      .click('button.searchForm', (err, result) ->
        assert.isNull err, "Error clicking search button"
      )
      .waitFor(link.samplecss, 8000, (err, result) ->
        assert.isNull err, "Expected search result not returned"
      )
      .call(done)

    it 'checks that search query information is included on results page', (done) ->
      client
      .getValue(input.given, (err, result) ->
        assert.isNull err, "Missing given on search results page search form"
        assert.equal result, "Bob"
      )
      .getValue(input.surname, (err, result) ->
        assert.isNull err, "Missing surname on search results page search form"
        assert.equal result, "Jones"
      )
      .getValue(input.birthplace, (err, result) ->
        assert.isNull err, "Missing birthplace on search results page search form"
        assert.equal result, "Idaho"
      )
      .getValue(input.birthfrom, (err, result) ->
        assert.isNull err, "Missing birthfrom on search results page search form"
        assert.equal result, "1900"
      )
      .getElementCssProperty('css selector', link.samplecss, 'color', (err, result) ->
        assert.isNull err, "Error in HR search results appearing"
        assert.equal result, 'rgba(0,81,196,1)', 'Wait a second - colors are off!!'
      )
      .call(done)

    it 'checks record details page title, tree and image links', (done) ->
      client
      .click(link.samplecss, (err, result) ->
        assert.isNull err, "Error clicking on sample search result"
      )
      .waitFor('.record-title', 8000, (err, result) ->
        assert.isNull err, "Expected search result not returned"
      )
      .waitFor(link.tree, 8000, (err, result) ->
        assert.isNull err, "Error calculating tree link"
      )
      .waitFor('a[href*="TH-1942-27758-3365-17"]', 8000, (err, result) ->
        assert.isNull err, "Error showing image link"
      )
      .getTitle((err, title) ->
        assert.isNull err, "Error in record detail title"
        assert.include title, 'Person Details for Bob Jones, "United States Census, 1940"'
      )
      .call(done)

    it 'loads the image viewer', (done) ->
      client
      .waitFor('.image-link', 8000, (err, result) ->
        assert.isNull err, "Image link not visible on details page"
      )
      .click(link.image, (err, result) ->
        assert.isNull err, "Error clicking image link"
      )
      .waitFor('.seadragonViewer', 18000, (err, result) ->
        assert.isNull err, "Error loading image viewer"
      )
      .getTitle((err, title) ->
        assert.isNull err, "Error getting title"
        assert.include title, 'TH-1942-27758-3365-17'
      )
      .waitFor(link.firstWaypoint, 18000,  (err, result) ->
        assert.isNull err, "Error with waypoint link"
      )
      .getText(link.firstWaypoint, (err, result) ->
        assert.equal result, 'United States Census, 1940'
      )
      .getText('ul.waypointBreadCrumbs li:nth-of-type(2) a', (err, result) ->
        assert.equal result, 'Oregon'
      )
      .call(done)


    it 'returns to search results using back button', (done) ->
      client
      .back((err, result) ->
        assert.isNull err, "Error returning from image viewer"
      )
      .back((err, result) ->
        assert.isNull err, "Error returning to search results"
      )
      .waitFor(link.samplecss, 8000, (err, result) ->
        assert.isNull err, "Error finding sample link"
      )
      .waitFor('.search-criteria .result', 8000, (err, result) ->
        assert.isNull err, "Did not find sample link"
        # assert.match result, /Bob Jones/, "search criteria not found"
      )
      .getText('.search-criteria .result', (err, result) ->
        assert.equal result, "Bob Jones"
      )
      .getTitle((err, title) ->
        assert.isNull err, "Error getting results page title"
        assert.include title, 'Search Results'
      )
      .call(done)


  