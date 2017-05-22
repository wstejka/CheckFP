###!/home/wstejka/virtualenv/firebase/bin/python


from lxml import html
import requests

#################### PARSERS #######################
import OrlenParser as orlenParser


# Let's define list of parsers
webPageList = { orlenParser: "http://www.orlen.pl/EN/ForBusiness/FuelWholesalePrices/Pages/default.aspx" }


for parser, webPage in webPageList.iteritems():
	try:
		functionName = parser.__name__
		print functionName, ": downloading data ..."
		webPageContent = requests.get(webPage)
		print functionName, ": parsing data ..."
		fuelPriceForTheDay = parser.parse(webPageContent)
		print functionName, ": get in response:", fuelPriceForTheDay.theDay, ",", fuelPriceForTheDay.fuelTypesList
	except Exception, e:
		print e
		continue




