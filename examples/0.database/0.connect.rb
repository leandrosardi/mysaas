require 'pg'
require 'sequel'

s = "postgres://blackstack:bsws2022@54.144.101.4:26257/defaultdb"
DB = Sequel.connect(s)
puts DB["SELECT 'Hello CockRouchDB!' AS message"].first[:message]
# ==> Hello CockRouchDB!

i = 0
while i < 10000 
    puts DB["SELECT 'hello CockRouchDB' AS message"].first[:message]
    sleep(1)
end