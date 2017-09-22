require 'http'
require 'json'
require 'sinatra'

#Include type checking for boolean
module Boolean; end
class TrueClass; include Boolean; end
class FalseClass; include Boolean; end

class Validator
	def initialize()
		@customers #the current list of customers
		@validation #the current json rules for validation
		@invalid = { "invalid_customers" => [] } #will be a subset of all customers read through
		@pageInfo
	end

	def read(url, page) #get the data

		requestUrl = url + '?page=' + page.to_s
		response = HTTP.get(requestUrl).to_s
		jsonInput = JSON.parse(response)
		@validation = jsonInput["validations"]
		@customers = jsonInput["customers"]
		@pageInfo = jsonInput["pagination"]
	end

	def output()
		puts @validation
		puts @customers
		puts @pageInfo
	end

	def validate()
		@customers.each do | customer |
			invalidJSON = { "id" => customer["id"], "invalid_fields" => [] }
			@validation.each do | rule |
				key, value = rule.first
				invalidFlag = false
				invalidFlag = value["required"] && !customer[key] 
				if value["type"] #if a type is specified, check the type
					types = {"number" => Numeric, "string" => String, "boolean" => Boolean}
					invalidFlag = !customer[key].is_a?(types[value["type"]])
				end
				if value["length"] && customer[key]
					range = value["length"]
					max = range["max"]
					min = range["min"]
					if(max && min)
						invalidFlag = customer[key].length < min || customer[key].length > max
					elsif max
						invalidFlag = customer[key].length > max
					else
						invalidFlag = customer[key].length < min
					end
				end
				if invalidFlag
					invalidJSON["invalid_fields"].push(key.to_s)
				end
			end
			if invalidJSON["invalid_fields"].size > 0
					@invalid["invalid_customers"].push(invalidJSON)
			end
		end
	end
	def returnInvalid()
		return @invalid.to_json
	end
end

get '/' do
    machine = Validator.new()
	(1..5).each do | page |
	machine.read('https://backend-challenge-winter-2017.herokuapp.com/customers.json', page)
	machine.validate()
	end
	machine.returnInvalid()
end

