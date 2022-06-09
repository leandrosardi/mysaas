# setup deploying rutines
BlackStack::Deployer::add_routine({
  :name => 'install-mysaas',
  :commands => [
    { 
        :command => 'mkdir ~/code',
        :matches => [ /^$/i, /File exists/i ],
        :sudo => false,
    }, { 
        :command => 'cd ~/code; git clone https://github.com/leandrosardi/mysaas',
        :matches => [ 
            /already exists and is not an empty directory/i,
            /Cloning into/i,
            /Resolving deltas\: 100\% \((\d)+\/(\d)+\), done\./i,
            /fatal\: destination path \'.+\' already exists and is not an empty directory\./i,
        ],
        :nomatches => [ # no output means success.
            { :nomatch => /error/i, :error_description => 'An Error Occurred' },
        ],
        :sudo => false,
    }, { 
        :command => 'cd ~/code/mysaas; git fetch --all',
        :matches => [/\-> origin\//, /^Fetching origin$/],
        :nomatches => [ { :nomatch => /error/i, :error_description => 'An error ocurred.' } ],
        :sudo => true,
    }, { 
        :command => 'cd ~/code/mysaas; git reset --hard origin/%git_branch%',
        :matches => /HEAD is now at/,
        :sudo => true,
    }, { 
        :command => 'source /home/%ssh_username%/.rvm/scripts/rvm; cd ~/code/mysaas; rvm install 3.1.2; rvm --default use 3.1.2; bundler update',
        :matches => [ 
            /Bundle updated\!/i,
        ],
        :nomatches => [ 
            { :nomatch => /not found/i, :error_description => 'An Error Occurred' },
        ],
        :sudo => true,
    }, {
        # 
        :command => 'export RUBYLIB=~/code/mysaas',
        :nomatches => [ 
            { :nomatch => /.+/i, :error_description => 'No output expected' },
        ],
        :sudo => false,

    }
  ],
});