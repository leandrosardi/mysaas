require 'pg'
require 'sequel'

s = "postgres://blackstack:bsws2022@54.144.101.4:26257/defaultdb"
DB = Sequel.connect(s)

i = 0
while i < 10000 
    puts DB["SELECT 'Hello CockrouchDB!' AS message"].first[:message]
    # ==> Hello CockrouchDB!
    sleep(1)
end