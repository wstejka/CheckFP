###!/home/wstejka/virtualenv/firebase/bin/python

##################    PARSERS    #######################
import OrlenParser as orlenParser
import LotosParser as lotosParser
from Firebase import FirebaseManager
from FuelModel import ProducerType, FuelType, FuelComponent
import sys, getopt, os
from datetime import datetime

fileName = os.path.basename(sys.argv[0])
login = ""
password = ""

########### Obtain login and password from param list #################
usage =  fileName + " -l <login> -p <password>\n"
try:
	opts, args = getopt.getopt(sys.argv[1:],"hl:p:",["login=","password="])
except getopt.GetoptError:
	print usage
	sys.exit(2)

for opt, arg in opts:
	if opt == '-h':
		print usage
		sys.exit()
	elif opt in ("-l", "--login"):
		login = arg
	elif opt in ("-p", "--password"):
		password = arg

# check if login and password are not empty
if login == "" or password == "" :
	print "Lack of authentication data ..."
	print usage
	exit(1)

# Let's define list of parsers
parsersList = {ProducerType.lotos : lotosParser } #, 
			   # ProducerType.orlen : orlenParser}

firebaseManager = FirebaseManager(login, password)

print "Preparing of initial data ...."
startTime = datetime.now()
# get current data for comparison
## INSTANCES
instancesNodeName = "instances"
currentInstanceDataList = firebaseManager.getDataFromNode(instancesNodeName)
if currentInstanceDataList.val() == None:
	currentInstanceDataListKeys = []
else:
	currentInstanceDataListKeys = currentInstanceDataList.val().keys()

## FUEL TYPE CATEGORY
nodeName = "fuel_types"
currentFuelTypesDataList = firebaseManager.getDataFromNode()
if currentFuelTypesDataList.val() == None:
	currentFuelTypesDataList = []
else
	currentFuelTypesDataList = currentFuelTypesDataList.val()

print "Data prepared in", str((datetime.now() - startTime).seconds), "seconds"

# Let's get current data
for producerId, parser in parsersList.iteritems():
	try:
		print parser.__name__, ":"
		# data: {1 : [FuelModel.FuelComponent, ..., FuelModel.FuelComponent]}
		#		...
		# 	    {N : [FuelModel.FuelComponent, ..., FuelModel.FuelComponent]}
		
		fuelComponentsList = parser.process(producerId)
		print
		print "\tpreparing data to save ..."
		startTime = datetime.now()


		newInstancesDataDict = {}
		fuelTypeSpecificDict = {}
		for fuelComponent in fuelComponentsList:
			dictKey = str(fuelComponent.producer) + "_" + str(fuelComponent.theDay) + "_" + str(fuelComponent.fuelType)
			if dictKey not in currentInstanceDataListKeys:
				newInstancesDataDict[dictKey] = fuelComponent.serialize()


		print "\tnumber of rows to update:", len(newInstancesDataDict)
		if len(allDataDict) == 0:
			print "\tAll price data are up to date"
			continue
		print "\tsaving data in firebase DB ..."
		startTime = datetime.now()
		firebaseManager.updateDB("", instancesNodeName, newInstancesDataDict)
		print "\tdata saved in firebase DB in", str((datetime.now() - startTime).seconds), "seconds"

	except Exception, e:
		print e
		continue


