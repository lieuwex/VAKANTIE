_ = require "lodash"
express = require "express"
compress = require "compression"
minify = require "express-minify"
request = require "request"
moment = require "moment"

north = ["noord", "aa en hunze", "eemsmond", "lelystad", "stede broec", "aalsmeer", "emmen", "lemsterland", "steenwijkerland", "achtkarspelen", "enkhuizen", "littenseradeel", "ten boer", "alkmaar", "enschede", "loppersum", "terschelling", "almelo", "ferwerderadeel", "losser", "texel", "almere", "franekeradeel", "marum", "tietjerksteradeel", "ameland", "gaasterland-sloten", "medemblik", "tubbergen", "amstelveen", "graft-de rijp", "menaldumadeel", "twenterand", "amsterdam", "groningen", "menterwolde", "tynaarlo", "andijk", "grootegast", "meppel", "uitgeest", "anna paulowna", "haaksbergen", "midden-drenthe", "uithoorn", "appingedam", "haarlem", "muiden", "urk", "assen", "haarlemmerliede", "naarden", "veendam", "bedum", "haarlemmermeer", "niedorp", "velsen", "beemster", "hardenberg", "nieuwkruisland", "vlagtwedde", "bellingwedde", "haren", "nijefurd", "vlieland", "bennebroek", "harenkarspel", "noordenveld", "waterland", "bergen (noord-holland)", "harlingen", "noordoostpolder", "weesp", "beverwijk", "hattem", "oldenzaal", "wervershoof", "blaricum", "heemskerk", "olst-wijhe", "westerveld", "bloemendaal", "heemstede", "ommen", "weststellingwerf", "bolsward", "heerenveen", "ooststellingwerf", "wierden", "boornsterhem", "heerhugowaard", "oostzaan", "wieringen", "borger-odoorn", "heiloo", "opmeer", "wieringermeer", "borne", "hellendoorn", "opsterland", "wijdemeren", "bussum", "hengelo", "ouder-amstel", "winschoten", "castricum", "het bildt", "pekela", "winsum", "coevorden", "hilversum", "purmerend", "wonseradeel", "dalfsen", "hof van twente", "raalte", "wormerland", "dantumadeel", "hoogeveen", "reiderland", "wymbritseradeel", "de marne", "hoogezand-sappemeer", "rijssen-holten", "zaanstad", "de wolden", "hoorn", "schagen", "zandvoort", "delfzijl", "huizen", "scharsterland", "zeevang", "den helder", "kampen", "scheemda", "zijpe", "deventer", "koggenland", "schermer", "zuidhorn", "diemen", "kollumerland", "schiermonnikoog", "zwartewaterland", "dinkelland", "landsmeer", "slochteren", "zwolle", "dongeradeel", "langedijk", "smallingerland", "drechterland", "laren", "sneek", "dronten", "leek", "spaarnwoude", "edam-volendam", "leeuwarden", "stadskanaal", "eemnes", "leeuwarderadeel", "staphorst"]
mid = ["midden", "aalten", "geldermalsen", "moordrecht", "teylingen", "abcoude", "giessenlanden", "nederlek", "tiel", "alblasserdam", "goedereede", "neerijnen", "utrecht", "albrandswaard", "gorinchem", "nieuw-lekkerland", "utrechtse heuvelrug", "alphen aan den rijn", "gouda", "nieuwegein", "veenendaal", "amersfoort", "graafstroom", "nieuwerkerk aan den ijssel", "vianen", "apeldoorn", "harderwijk", "nieuwkoop", "vlaardingen", "baarn", "hardinxveld-giessendam", "nijkerk", "vlist", "barendrecht", "heerde", "noordwijk", "voorschoten", "barneveld", "hellevoetsluis", "noordwijkerhout", "voorst", "bergambacht", "hendrik-ido-ambacht", "nunspeet", "waddinxveen", "bernisse", "hillegom", "oegstgeest", "wageningen", "binnenmaas", "houten", "oldebroek", "wassenaar", "bodegraven", "ijsselstein", "oostflakkee", "werkendam", "boskoop", "kaag en braassem", "oud-beijerland", "westland", "breukelen", "katwijk", "ouderkerk", "westvoorne", "brielle", "korendijk", "oudewater", "wijk bij duurstede", "brummen", "krimpen aan den ijssel", "papendrecht", "winterswijk", "bunnik", "lansingerland", "pijnacker-nootdorp", "woerden", "bunschoten", "leerdam", "putten", "woudenberg", "buren", "leiden", "reeuwijk", "woudrichem", "capelle aan den ijssel", "leiderdorp", "renswoude", "zederik", "cromstrijen", "leidschendam-voorburg", "rhenen", "zeewolde", "culemborg", "leusden", "ridderkerk", "zeist", "de bilt", "liesveld", "rijnwoude", "zevenhuizen-moerkapelle", "de ronde venen", "lingewaal", "rijswijk", "zoetermeer", "delft", "lisse", "rotterdam", "zoeterwoude", "den haag", "lochem", "rozenburg", "zutphen", "dirksland", "loenen", "scherpenzeel", "zwijndrecht", "doetinchem", "lopik", "schiedam", "dordrecht", "maarssen", "schoonhoven", "ede", "maassluis", "sliedrecht", "elburg", "middelharnis", "soest", "epe", "midden-delfland", "spijkenisse", "ermelo", "montfoort", "strijen"]
south =  ["zuid", "aalburg", "gemert-bakel", "meijel", "sluis", "alphen-chaam", "gennep", "middelburg", "someren", "arcen en velden", "gerwen", "mill en sint hubert", "son en breugel", "arnhem", "gilze en rijen", "millingen aan de rijn", "steenbergen", "asten", "goes", "moerdijk", "stein", "baarle-nassau", "goirle", "mook en middelaar", "terneuzen", "beek", "grave", "nederweert", "tholen", "beesel", "groesbeek", "nederwetten", "tilburg", "bergeijk", "gulpen-wittem", "nijmegen", "ubbergen", "bergen (limburg)", "haaren", "noord-beveland", "uden", "bergen op zoom", "halderberge", "nuenen", "vaals", "bernheze", "heerlen", "nuth", "valkenburg aan de geul", "best", "heeze-leende", "oirschot", "valkenswaard", "beuningen", "helden", "oisterwijk", "veere", "bladel", "helmond", "onderbanken", "veghel", "boekel", "heumen", "oosterhout", "veldhoven", "borsele", "heusden", "oss", "venlo", "boxmeer", "hilvarenbeek", "overbetuwe", "venray", "boxtel", "horst aan de maas", "reimerswaal", "vlissingen", "breda", "hulst", "renkum", "voerendaal", "brunssum", "kapelle", "reusel-de mierden", "vught", "cranendonck", "kerkrade", "rheden", "waalre", "cuijk", "kessel", "rijnwaarden", "waalwijk", "den bosch (s-hertogenbosch)", "laarbeek", "roerdalen", "weert", "deurne", "landerd", "roermond", "west maas en waal", "doesburg", "landgraaf", "roosendaal", "westervoort", "dongen", "leudal", "rozendaal", "wijchen", "drimmelen", "lith", "rucphen", "woensdrecht", "druten", "loon op zand", "schijndel", "zaltbommel", "duiven", "maasbree", "schinnen", "zevenaar", "echt-susteren", "maasdonk", "schouwen-duiveland", "zundert", "eersel", "maasdriel", "sevenum", "eijsden", "maasgouw", "simpelveld", "eindhoven", "maastricht", "sint anthonis", "etten-leur", "margraten", "sint-michielsgestel", "geertruidenberg", "meerlo-wanssum", "sint-oedenrode", "geldrop-mierlo", "meerssen", "sittard-geleen"]

app = express()
app.set "view engine", "jade"
moment.locale "nl"

app.use compress filter: -> yes # Compress EVERYTHING
app.use minify()
app.use express.static __dirname + "/public"
app.use "/js", express.static __dirname + "/js"
app.use "/css", express.static __dirname + "/css"

app.use (req, res, next) ->
	res.header "Access-Control-Allow-Origin", "*"
	res.header "Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept"
	next()

onError = (err, req, res, next) ->
	console.log err.stack
	res.status(500).end "dat 500 tho."
app.use onError

vacationData = []
fetchVacationData = ->
	firstYear = lastYear = null
	currentYear = new Date().getUTCFullYear()

	if new Date().getMonth() >= 7 # first half schoolyear.
		firstYear = currentYear
		lastYear = currentYear + 1
	else
		firstYear = currentYear - 1
		lastYear = currentYear

	request "http://opendata.rijksoverheid.nl/v1/sources/rijksoverheid/infotypes/schoolholidays/schoolyear/#{firstYear}-#{lastYear}?output=json&rows=2", (req, res, body) ->
		try
			vacationData = JSON.parse(body).content[0].vacations
fetchVacationData(); setInterval fetchVacationData, 43200000

app.get "/", (req, res) ->
	res.render "main"

app.get "/:location", (req, res) ->
	unless _.contains north.concat(mid).concat(south), req.params.location.toLowerCase()
		res.status(404).end()
		return

	location = null
	if _.contains(north, req.params.location.toLowerCase()) then location = "noord"
	else if _.contains(mid, req.params.location.toLowerCase()) then location = "midden"
	else if _.contains(south, req.params.location.toLowerCase()) then location = "zuid"

	m = moment _(vacationData).pluck("regions").flatten().find((d) ->
		correctRegion = d.region is location or d.region is "heel Nederland"
		future = new Date(d.startdate) > new Date()
		return correctRegion and future
	).startdate

	res.end moment.duration(m.diff new Date()).humanize()

port = process.env.PORT || 5000
app.listen port, -> console.log "Running on port #{port}"
