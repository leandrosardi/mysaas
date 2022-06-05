# setup deploying rutines
BlackStack::Deployer::add_routine({
  :name => 'start-mysaas',
  :commands => [
    { 
        # back up old configuration file
        # setup new configuration file
        :command => "
          source /home/%ssh_username%/.rvm/scripts/rvm; rvm install 3.1.2; rvm --default use 3.1.2 > /dev/null 2>&1;
          cd /home/%ssh_username%/code/mysaas > /dev/null 2>&1; 
          pkill puma > /dev/null 2>&1;
          pkill ruby > /dev/null 2>&1;
          export RUBYLIB=/home/%ssh_username%/code/mysaas > /dev/null 2>&1;
          nohup ruby app.rb port=%web_port% > /dev/null 2>&1 &
        ",
        :matches => [ /Already installed ruby/ ],
        #:nomatches => [ { :nomatch => /.+/, :error_description => 'No output expected.' } ],
        :sudo => true,
    },
  ],
});
