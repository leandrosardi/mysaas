# this routine install 
BlackStack::Deployer::add_routine({
  :name => 'start-crdb-environment',
  :commands => [
    {
        :sudo=> true,
        # CRDB is not supporting the restarting of a working node, and it fails after that. 
        # Reference: https://github.com/leandrosardi/free-membership-sites/issues/3#issuecomment-1145029801
        :command => :reboot, 
    }, {
        :sudo=> true,
        :command => '
cd ~; 
mv %crdb_database_certs_path%/certs %crdb_database_certs_path%/certs.back.%timestamp%;
mkdir %crdb_database_certs_path%/certs;
mkdir -p %crdb_database_certs_path%/my-safe-directory;
cockroach cert create-ca --allow-ca-key-reuse --certs-dir=%crdb_database_certs_path%/certs --ca-key=%crdb_database_certs_path%/my-safe-directory/ca.key;
cockroach cert create-node localhost %eth0_ip% %net_remote_ip% $(hostname) --certs-dir %crdb_database_certs_path%/certs --ca-key %crdb_database_certs_path%/my-safe-directory/ca.key;
cockroach cert create-client root --certs-dir=%crdb_database_certs_path%/certs --ca-key=%crdb_database_certs_path%/my-safe-directory/ca.key;
        ',
        :nomatches => [{ :nomatch => /.+/, :error_description => 'no output is expected' }], # TODO: no output is expected.
    }, {
        :command => 'cockroach start --background --max-sql-memory=.25 --cache=.25 --advertise-addr=%net_remote_ip%:%crdb_database_port% --certs-dir=%crdb_database_certs_path%/certs --store=%name% --listen-addr=%eth0_ip%:%crdb_database_port% --http-addr=%eth0_ip%:%crdb_dashboard_port% --join=%net_remote_ip%:%crdb_database_port%;',
        :matches => [/Cluster successfully initialized/, /cluster has already been initialized/],
        :nomatches => [
          { :nomatch => /Failed running "start"/, :error_description => "Failed to start node" },
        ] 
    },
  ],
});

#
#cockroach init --host=%eth0_ip%:%crdb_database_port% --certs-dir=%crdb_database_certs_path%/certs;
