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

	def set(self, nodeName, dictKey, dictData):
		
		# companies = db.child("companies").get()
		# print self.userIdToken
		self.db.child(nodeName).child(dictKey).set(dictData, self.userIdToken)

	def  get(self, nodeName, shallow=None):
		if shallow == True:
			return self.db.child(nodeName).shallow().get(self.userIdToken)
		else:
			return self.db.child(nodeName).get(self.userIdToken)

	def  remove(self, nodeName):
		return self.db.child(nodeName).remove(self.userIdToken)

	def  update(self, data):
		return self.db.update(data, self.userIdToken)

if __name__ == "__main__":
   
	# firebaseManager.("", "test", {"kot" : "domek"})
	# print firebaseManager.get("test").val()
	# print firebaseManager.userIdToken
	firebaseManager.remove("instances")





