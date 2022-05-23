require 'pg'
require 'sequel'

DB = Sequel.connect('postgres://postgres:Amazonia2020@127.0.0.1/kepler') 

puts DB['select count(*) as n from "user"'].first[:n].to_s