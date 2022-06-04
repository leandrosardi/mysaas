# setup deploying rutines
BlackStack::Deployer::add_routine({
  :name => 'setup-mysaas',
  :commands => [
    { 
        # reference: https://askubuntu.com/questions/504546/error-message-source-not-found-when-running-a-script
        :command => "source /home/%ssh_username%/.rvm/scripts/rvm; rvm install 3.1.2; rvm --default use 3.1.2;export RUBYLIB=~/code/mysaas;", 
        :matches => [ /Already installed/i,  /installed/i, /generating default wrappers/i ],
        :sudo => false,    
    }, { 
        # back up old configuration file
        # setup new configuration file
        :command => "
            cd ~/code/mysaas; 
            pkill ruby;
            source /home/%ssh_username%/.rvm/scripts/rvm; rvm install 3.1.2; rvm --default use 3.1.2;export RUBYLIB=~/code/mysaas;
            nohup ruby app.rb &
        ",
        #:matches => [ /^$/, /mv: cannot stat '\.\/config.rb': No such file or directory/ ]
        #:nomatches => [ { :nomatch => /.+/, :error_description => 'No output expected.' } ],
        :sudo => false,
    },
  ],
});
