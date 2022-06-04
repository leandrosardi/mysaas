# setup deploying rutines
BlackStack::Deployer::add_routine({
  :name => 'install-free-membership-sites',
  :commands => [
    { 
        :command => 'mkdir ~/code',
        :matches => [ /^$/i, /File exists/i ],
        :sudo => false,
    }, { 
        :command => 'cd ~/code; git clone https://github.com/leandrosardi/free-membership-sites',
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
        :command => 'cd ~/code/free-membership-sites; git fetch --all',
        :matches => [/\-> origin\//, /^Fetching origin$/],
        :nomatches => [ { :nomatch => /error/i, :error_description => 'An error ocurred.' } ],
        :sudo => false,
    }, { 
        :command => 'cd ~/code/free-membership-sites; git reset --hard origin/%git_branch%',
        :matches => /HEAD is now at/,
        :sudo => false,
    }, { 
        :command => 'source /home/%ssh_username%/.rvm/scripts/rvm; cd ~/code/free-membership-sites; rvm install 3.1.2; rvm --default use 3.1.2; bundler update',
        :matches => [ 
            /Bundle updated\!/i,
        ],
        :nomatches => [ 
            { :nomatch => /not found/i, :error_description => 'An Error Occurred' },
        ],
        :sudo => false,
    },
  ],
});