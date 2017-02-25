_        = require 'lodash'
express  = require 'express'
compress = require 'compression'
minify   = require 'express-minify'
request  = require 'request'
moment   = require 'moment'
friendly = require './friendly.js'

north    = require './json/north.json'
mid      = require './json/mid.json'
south    = require './json/south.json'

app = express()
app.set 'view engine', 'jade'
moment.locale 'nl'

app.use compress filter: -> yes # Compress EVERYTHING
app.use minify()
app.use express.static __dirname + '/public'
app.use '/js', express.static __dirname + '/js'
app.use '/css', express.static __dirname + '/css'

app.use (req, res, next) ->
	res.header 'Access-Control-Allow-Origin', '*'
	res.header 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept'
	next()

app.use (err, req, res, next) ->
	console.log err.stack
	res.status(500).end 'dat 500 tho.'

vacationData = []
fetchVacationData = ->
	currentYear = new Date().getUTCFullYear()

	if new Date().getMonth() >= 7 # first half schoolyear.
		firstYear = currentYear
		lastYear = currentYear + 1
	else
		firstYear = currentYear - 1
		lastYear = currentYear

	request "http://opendata.rijksoverheid.nl/v1/sources/rijksoverheid/infotypes/schoolholidays/schoolyear/#{firstYear}-#{lastYear}?output=json&rows=2", (req, res, body) ->
		try
			parsed = JSON.parse body
			vacationData = parsed.content[0].vacations

fetchVacationData(); setInterval fetchVacationData, 1000 * 60 * 60 * 12 # 12h

app.get '/', (req, res) ->
	res.render 'main'

app.get '/:location', (req, res) ->
	unless vacationData?
		res.status(500).end()
		return

	clean = (str) -> str.toLowerCase().replace /\W/g, ''

	city = clean req.params.location
	location = (
		check = (val) -> clean(val) is city

		if _.some north, check
			'noord'
		else if _.some mid, check
			'midden'
		else if _.some south, check
			'zuid'
	)

	unless location?
		res.status(404).end()
		return

	info = _(vacationData)
		.map 'regions'
		.flatten()
		.find (d) ->
			correctRegion = d.region is location or d.region is 'heel Nederland'
			future = new Date(d.startdate) > new Date()

			correctRegion and future

	unless info?
		res.status(420).end()
		return

	start = moment info.startdate
	end = moment info.enddate

	res.json
		friendly: friendly moment.duration start.diff(new Date)
		startDate: start.format()
		endDate: end.format()

port = process.env.PORT ? 5000
app.listen port, -> console.log "Running on port #{port}"
