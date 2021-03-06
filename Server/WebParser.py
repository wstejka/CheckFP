###!/home/wstejka/virtualenv/firebase/bin/python

##################    PARSERS    #######################
import OrlenParser as orlenParser
import LotosParser as lotosParser
from Firebase import FirebaseManager
from FuelModel import Producer, Fuel, FuelPriceElement
import sys, getopt, os
from datetime import datetime


def initiateOrUpdateModelNodesInFirebaseDB():
	"""This method initiates pre-defined models with "id" and "name" values.
	It also checks data consistency and does an update if needed.
	As a source are taken model objects e.g. Fuel or Producer."""
	
	nodeLists = {"producers" : Producer(), "fuel_types" : Fuel()}

	for nodeName, instance in nodeLists.iteritems():
		print "\tChecking \"" + nodeName + "\" node data consistency ..."
		preDefinedValues = instance.properties(["none"]).iteritems()
		firebaseObjectsList = firebaseManager.get(nodeName)

		if firebaseObjectsList.val() == None:
			firebaseObjectsListKeys = [{}]
		else:
			firebaseObjectsListKeys = firebaseObjectsList.val()

		# Check if all predefined values are already on the list		
		# If not, add the missing ones ...
		missingTypeKeys = {}
		for keyName, key in preDefinedValues:		
			found = False
			for firebaseObjectKey in firebaseObjectsListKeys:
				
				if firebaseObjectKey == None or \
					'id' not in firebaseObjectKey:
					continue
				if key == firebaseObjectKey['id']:
					found = True
					break

				# print key, firebaseFuelsKey

			if found == False:
				print "\t", keyName, "(" + str(key) + ")" + " is not on the list. Let's add it ..."
				# [{1 : {"name" : "name1", "id" : 1},
				# 	2 : {"name" : "name2", "id" : 2]
				missingTypeKeys[nodeName + "/" + str(key)] = {"id" : key, 
															  "name" : keyName}

		numberOfMissingTypeKeys = len(missingTypeKeys)
		if numberOfMissingTypeKeys > 0:
			print "\tAdding", numberOfMissingTypeKeys , "missing fuel types to the", nodeName
			firebaseManager.update(missingTypeKeys)
		else:
			print "\t" + nodeName, "node is up to date"		

# end def		

# fuel_type
def updateFuelTypesNode(newPricesList):

	nodeName = "fuel_types"
	firebaseFuelsList = firebaseManager.get(nodeName)
	if firebaseFuelsList.val() == None:
		return False
	
	currentHighestPriceNode = "currentHighestPrice"
	currentLowestPriceNode = "currentLowestPrice"
	currentHighestPriceRefNode = "currentHighestPriceReference"
	currentLowestPriceRefNode = "currentLowestPriceReference"
	currentAveragePriceNode = "currentAveragePrice"
	timestamp = "timestamp"
	currentFuelsPriceMatrix = {}
	for fuelType in firebaseFuelsList.val():

		if fuelType == None:
			continue

		currentHighestPrice = 0.0
		currentLowestPrice = 0.0
		currentPriceTimestamp = 0
		currentHighestPriceReference = ""
		currentLowestPriceReference = ""

		if currentHighestPriceNode in fuelType:
			currentHighestPrice = fuelType[currentHighestPriceNode]
		if currentLowestPriceNode in fuelType:
			currentLowestPrice = fuelType[currentLowestPriceNode]
		if timestamp in fuelType:
			currentPriceTimestamp = fuelType[timestamp]

		keyNodePrefix = nodeName + "/" + str(fuelType["id"]) +"/"
		currentFuelsPriceMatrix[keyNodePrefix + currentHighestPriceNode] = currentHighestPrice
		currentFuelsPriceMatrix[keyNodePrefix + currentLowestPriceNode] = currentLowestPrice
		currentFuelsPriceMatrix[keyNodePrefix + timestamp] = currentPriceTimestamp

	isUpdate = False
	for fuelPrice in newPricesList[:]:
		key = fuelPrice.key()

		highestPriceRefKey = nodeName + "/" +str(fuelPrice.fuelType) + "/" + currentHighestPriceNode 
		lowestPriceRefKey = nodeName + "/" +str(fuelPrice.fuelType) + "/" + currentLowestPriceNode 
		timestampRefKey = nodeName + "/" +str(fuelPrice.fuelType) + "/" + timestamp
		highestPriceReferenceRefKey = nodeName + "/" +str(fuelPrice.fuelType) + "/" + currentHighestPriceRefNode 
		lowestPriceReferenceRefKey = nodeName + "/" +str(fuelPrice.fuelType) + "/" + currentLowestPriceRefNode 

		# If the timestamp is later than current there is needed to update all data
		if currentFuelsPriceMatrix[timestampRefKey] < fuelPrice.timestamp:
			currentFuelsPriceMatrix[timestampRefKey] = fuelPrice.timestamp
			currentFuelsPriceMatrix[highestPriceRefKey] = fuelPrice.price
			currentFuelsPriceMatrix[highestPriceReferenceRefKey] = fuelPrice.key()
			currentFuelsPriceMatrix[lowestPriceRefKey] = fuelPrice.price
			currentFuelsPriceMatrix[lowestPriceReferenceRefKey] = fuelPrice.key()
			isUpdate = True
										
		# If the timestamp is equal to current there is needed to compare values
		# and do update if needed
		elif currentFuelsPriceMatrix[timestampRefKey] == fuelPrice.timestamp:

			if currentFuelsPriceMatrix[highestPriceRefKey] == 0 or \
				currentFuelsPriceMatrix[highestPriceRefKey] < fuelPrice.price:
				isUpdate = True
				currentFuelsPriceMatrix[highestPriceRefKey] = fuelPrice.price
				currentFuelsPriceMatrix[highestPriceReferenceRefKey] = fuelPrice.key()

			if currentFuelsPriceMatrix[lowestPriceRefKey] == 0 or \
				currentFuelsPriceMatrix[lowestPriceRefKey] > fuelPrice.price:
				isUpdate = True
				currentFuelsPriceMatrix[lowestPriceRefKey] = fuelPrice.price
				currentFuelsPriceMatrix[lowestPriceReferenceRefKey] = fuelPrice.key()
	# end for

	if isUpdate:
		print "\tsaving", nodeName , "data in firebase DB ..."
		startTime = datetime.now()
		firebaseManager.update(currentFuelsPriceMatrix)
		print "\tdata saved in firebase DB in", str((datetime.now() - startTime).seconds), "second(s)"
	else:
		print "\tall data in", nodeName ,"node are up to date"




# fuel_price_instances
def updateFuelPriceInstancesNodeIfNeeded():

	print "Preparing initial data ...."
	startTime = datetime.now()
	# get current data for comparison
	## INSTANCES
	instancesNodeName = "fuel_price_items"
	currentInstanceDataList = firebaseManager.get(instancesNodeName)
	if currentInstanceDataList.val() == None:
		currentInstanceDataListKeys = []
	else:
		currentInstanceDataListKeys = currentInstanceDataList.val().keys()

	## FUEL TYPE CATEGORY
	print "Data prepared in", str((datetime.now() - startTime).seconds), "second(s)"

	# Let's get current data
	for producerId, parser in parsersList.iteritems():
		try:
			print
			print parser.__name__, ":"
			# data: {1 : [FuelModel.FuelPriceElement, ..., FuelModel.FuelPriceElement]}
			#		...
			# 	    {N : [FuelModel.FuelPriceElement, ..., FuelModel.FuelPriceElement]}
			
			fuelPriceElementsList = parser.process(producerId)
			print
			print "\tpreparing data to save ..."
			startTime = datetime.now()

			newInstancesDataDict = {}
			newPriceElementsList = []
			for fuelPriceElement in fuelPriceElementsList:
				dictKey = fuelPriceElement.key()
				if dictKey not in currentInstanceDataListKeys:
					newInstancesDataDict[instancesNodeName + "/" + dictKey] = fuelPriceElement.serialize()
					newPriceElementsList.append(fuelPriceElement)

			numberOfNewInstances = len(newInstancesDataDict)
			print "\tnumber of rows to update:", numberOfNewInstances
			if numberOfNewInstances == 0:
				print "\tall prices data are up to date"
				continue
			print "\tsaving prices data in firebase DB ..."

			if numberOfNewInstances > 10:
				numberOfNewInstances = 10
			for position in range(0, numberOfNewInstances):
				print newPriceElementsList[position].serialize()

			startTime = datetime.now()
			firebaseManager.update(newInstancesDataDict)
			print "\tdata saved in firebase DB in", str((datetime.now() - startTime).seconds), "second(s)"

			updateFuelTypesNode(newPriceElementsList)
		except Exception, e:
			print "++++++++++++++++ ERROR ++++++++++++++++"
			print e
			print "+++++++++++++++++++++++++++++++++++++++"
			continue


##################################################
#################### MAIN ########################
##################################################

# Public variables
fileName = os.path.basename(sys.argv[0])

# Let's define list of parsers
parsersList = {Producer.orlen : orlenParser,
				Producer.lotos : lotosParser}

##################  AUTHENTICATION ######################
print "Connecting to firebase ...."
startTime = datetime.now()
# Handler to firebaseManager object
firebaseManager = FirebaseManager()
print "Connected in", str((datetime.now() - startTime).seconds), "seconds"

######################  STEP 1 ##########################
###########  UPDATE MODEL TABLES IF NEEDED  #############
initiateOrUpdateModelNodesInFirebaseDB()

######################  STEP 2 ##########################
updateFuelPriceInstancesNodeIfNeeded()













