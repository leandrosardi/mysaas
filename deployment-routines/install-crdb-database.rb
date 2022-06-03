# this routine install 
BlackStack::Deployer::add_routine({
  :name => 'install-crdb-database',
  :commands => [
    { 
        :command => "cockroach sql --host %eth0_ip%:%crdb_dashboard_port% --certs-dir certs -e \"CREATE USER blackstack WITH PASSWORD 'bsws2022';\"",
        :matches => /CREATE ROLE/
    }, {
        :command => "cockroach sql --host %eth0_ip%:%crdb_dashboard_port% --certs-dir certs -e \"CREATE DATABASE blackstack
WITH
--OWNER = blackstack
ENCODING = 'UTF8'
--LC_COLLATE = 'Spanish_Argentina.1252'
--LC_CTYPE = 'Spanish_Argentina.1252'
--TABLESPACE = pg_default
CONNECTION LIMIT = -1;\"",
        :matches => /CREATE DATABASE/
    }, {
        :command => "cockroach sql --host %eth0_ip%:%crdb_dashboard_port% --certs-dir certs -e \"GRANT ALL ON DATABASE blackstack TO blackstack;\"",
        :matches => /GRANT/
    }, {
        :command => "cockroach sql --host %eth0_ip%:%crdb_dashboard_port% --certs-dir certs -e \"SHOW GRANTS ON DATABASE blackstack;\"",
        :matches => /database_name\.*|\.*grantee\.*|\.*privilege_type/
    }
  ],
});

#cockroach start --certs-dir=certs --store=%name% --listen-addr=%eth0_ip%:%crdb_database_port% --http-addr=%eth0_ip%:%crdb_dashboard_port% --join=%eth0_ip%:%crdb_database_port% --background --max-sql-memory=.25 --cache=.25;
#cockroach init --host=%eth0_ip%:%crdb_database_port% --certs-dir=certs;
#:matches => /Cluster successfully initialized/,
