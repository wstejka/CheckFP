#!/home/wstejka/virtualenv/firebase/bin/python
import pyrebase
import sys, getopt

config = {
  "apiKey": "AIzaSyB5gJnV0cCayzgD5sZHhUCGovrJiPlozcU",
  "authDomain": "checkfuelprice-d5d3d.firebaseapp.com",
  "databaseURL": "https://checkfuelprice-d5d3d.firebaseio.com/",
  "storageBucket": "gs://checkfuelprice-d5d3d.appspot.com"
}

class FirebaseManager(object):
	"""docstring for FirebaseManager"""

	login = ""
	password = ""
	firebase = None
	db = None
	userIdToken = None

	def __init__(self, login=None, password=None):

		self.login = login
		self.password = password
		firebase = pyrebase.initialize_app(config)

		###### AUTHENTICATION ############
		# Get a reference to the auth service
		auth = firebase.auth()

		# Log the user in
		user = auth.sign_in_with_email_and_password(self.login, self.password)
		# Refresh token as it can expire after 1 hour
		user = auth.refresh(user['refreshToken'])
		# now we have a fresh token
		self.userIdToken = user['idToken']

		######## DATABASE #####################
		# Get a reference to the database service
		self.db = firebase.database()

	def updateDB(self, nodeName, dictKey, dictData):
		
		# companies = db.child("companies").get()
		# print self.userIdToken
		self.db.child(nodeName).child(dictKey).set(dictData, self.userIdToken)

	def  getDataFromNode(self, nodeName):
		return self.db.child(nodeName).get(self.userIdToken)


if __name__ == "__main__":
   
	firebaseManager = FirebaseManager("wojciechaux@gmail.com", "Anna123$")
	firebaseManager.updateDB("", "test", {"kot" : "domek"})

	print firebaseManager.getDataFromNode("test").val()
	# firebaseManager.updateDB({});





