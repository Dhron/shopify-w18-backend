require 'http'
require 'json'
#need to loop for more than just the first page

class validator
	def initialize(json)
		@json = json
		@required; #boolean
		@type; #array of strings
		@length; #array [max, min]
	end
	def validate(input)
		
	end
end

res = HTTP.get('https://backend-challenge-winter-2017.herokuapp.com/customers.json').to_s
resJSON = JSON.parse(res);

validation = resJSON["validations"]
customers = resJSON["customers"]
pageInfo = resJSON["pagination"]

puts validation
puts customers
puts pageInfo

validatorMachine = new validator(validation)


#you could make a validation object with certain properties
#by reading and assigning the properties in the validation obj
#test the cases against the object

#create a tree out of the information and then
#do a traversal?



#need to write a way to validate a json object
#general structure:
#'name': {
#   'required': (BOOL), (defaults to false if not provided)
#   'type': ("boolean", "number", or "string") (if not provided, any type is valid
#   'length': {
#       'min': (int),
#       'max': (int)
#   }
#}

#so they provide you with a schema, and then you validate the customer submission based on the schema

#also create an api:
#POST /schema, this returns the schema being used
#POST /submission, this returns the valid or invalid json