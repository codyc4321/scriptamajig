

alias brc='nano ~/.bash_profile'
alias src='source ~/.bash_profile'
alias up='cd ..'
alias st='git status'

mycmpushall(){
  git add -A
  git cm -m "$1"
  git push
}

alias goo="google-chrome"


eval $(thefuck --alias)

# Kodus]

export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# temporary hack due to python2 issue on mac
# export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2.7

# Rust settings
export PATH="$HOME/.cargo/bin:$PATH"

SSH="$HOME/.ssh"
SCRIPTS="$HOME/scripts"
PROJECTS="$HOME/projects"
WORK_PROJECTS="$HOME/work_projects"
TRILOGY_LESSON_PLANS_REPO="$HOME/projects/trilogy_TA_class/lesson_plans"

export PYTHONPATH="${PYTHONPATH}:$SCRIPTS"
export PYTHONPATH="${PYTHONPATH}:$WORK_PROJECTS"
export PYTHONPATH="${PYTHONPATH}:$TRILOGY_LESSON_PLANS_REPO"
# export ANDROID_HOME="$HOME/Android/Sdk"

# DIRECTORIES*
BASH_SCRIPTS_PATH="$SCRIPTS/bash"
CODE_META_SCRIPTS_PATH="$SCRIPTS/code_meta"
AST_SCRIPTS_PATH="$CODE_META_SCRIPTS_PATH/ast"
DJANGO_SCRIPTS_PATH="$SCRIPTS/django_scripts"
FAKE_SCRIPTS_PATH="$SCRIPTS/fake"
GENERAL_SCRIPTS_PATH="$SCRIPTS/general"
GIT_SCRIPTS_PATH="$SCRIPTS/git_and_bitbucket"
MISCELLANEOUS_SCRIPTS_PATH="$SCRIPTS/miscellaneous"
MPOS_SCRIPTS_PATH="$SCRIPTS/mpos"
UNITTESTS_SCRIPTS_PATH="$SCRIPTS/unittests"
UPDATES_SCRIPTS_PATH="$SCRIPTS/updates"
WORK_SCRIPTS_PATH="$SCRIPTS/work_scripts"
WORKON_SCRIPTS_PATH="$SCRIPTS/workon"
# END


# UTILS*
openwebpage(){
    echo $1
    if [ "$(uname)" == "Darwin" ]; then # Darwin == the OS mac is built on (linux variant)
        /usr/bin/open -a "/Applications/Google Chrome.app" $1
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        google-chrome $1
    fi
}

my_ip(){
    if [ "$(uname)" == "Darwin" ]; then
        echo "$(ipconfig getifaddr en0)"
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # https://askubuntu.com/questions/430853/how-do-i-find-my-internal-ip-address
        # ifconfig -a
        #   or
        # ip addr show
        #   or
        # ip route get 8.8.8.8 | awk '{print $NF; exit}'
        #   or
        hostname -I
    fi
}
# END

# WORKON*
nyble() {
    atom ~/projects/foodtruck-remake/frontend
    atom ~/projects/foodtruck-remake/server_nyble
    cd ~/projects/foodtruck-remake/server_nyble
    workon foodtruck
    python3 manage.py runserver
}

nyblefrontend() {
    cd ~/projects/foodtruck-remake/frontend
    npm i
    npm start
}

alias workonnyble='nyble'
alias workonnyblefrontend='nyblefrontend'

trilogy() {
    openwebpage https://github.com/coding-boot-camp/FullStack-Lesson-Plans/tree/master/02-lesson-plans/part-time
    openwebpage https://github.com/the-Coding-Boot-Camp-at-UT/04-2017-Austin-Class-Repository#curriculum-by-week
    echo "What week is the class in?"
    read week
    atom ~/projects/trilogy_TA_class/lesson-plans/01-Class-Content/$week*
    atom ~/projects/trilogy_TA_class/supporting-scripts-trilogy
}

alias workontrilogy='trilogy'
# END


# GENERAL*
alias listbash='$BASH_SCRIPTS_PATH/list_bash.py'
alias l='tree -L 3'
alias aps='chmod 755 $*'
alias brc='nano ~/.bash_profile'
alias atombashprofile='atom ~/.bash_profile'
alias bhistory='cat ~/.bash_history'
alias pycharm='/usr/local/pycharm-edu-2.0.4/bin/pycharm.sh'
# http://stackoverflow.com/questions/9168392/shell-script-to-kill-the-process-listening-on-port-3000
alias killport="fuser -k -n tcp $1"
# END


# CD*
alias up='cd ..; pwd; ls'
alias mydocs='cd $HOME/my_documents; ls'
alias doc='cd $HOME/Documents; ls'
alias dl='cd $HOME/Downloads; ls'
alias pr='cd $HOME/projects; ls'
alias wpr='cd $HOME/work_projects; ls'
alias tutorials='cd $HOME/tutorials; ls'
alias scr='cd $SCRIPTS; ls'
alias pys='cd $PYSCR; ls'
alias setupscripts='cd ~/scripts/setup_scripts/; ls'
alias django-class='cd $HOME/django_class'
alias cdbootcamp='cd ~/projects/trilogy_TA_class/lesson-plans/01-Class-Content'
# END


# RUN*
cdproject() { cd $HOME/projects/$1; workon $1 ;}
cdwkproject() { cd $WORK_PROJECTS/$1; workon $1 ;}
runproject() { cd $HOME/projects/$1; workon $1; port $2 ; sleep 3; google-chrome 127.0.0.1:$2 & }
# END


# WORK

# WORK END

# END


# DIGITAL OCEAN*
alias droplet='ssh root@155.55.55.555'
# END


# CLOUD*
alias cloudsqlconnect='mysql --host=104.197.156.69 --user=root --password'
alias cloudsqlproxy='~/cloud_sql_proxy -instances=homebrew-test:us-central1:homebrew-test-db=tcp:3306'
# END



# DOCKER*
# this command needs to be run sometimes, idk why
# make sure to use the mac installer, not bash
# eval "$(docker-machine env default)"

# To visit Docker container urls, remember on Mac you have to find the Docker Machine IP first:
#    $ docker-machine ip default
#    192.168.99.100

# Now take that IP and hit the url like "http://192.168.99.100:8888/healthcheck"
# assuming your app is running on 8888

alias dkrrestart='eval $(docker-machine env default)'

dkrremake(){
    docker-machine rm default -y
    docker-machine create default --driver virtualbox
    eval $(docker-machine env default)
    docker run hello-world
}

alias dkrreload='sudo systemctl daemon-reload && sudo systemctl restart docker.service'
alias dkrremoveall='docker stop $(docker ps -a -q); docker rm $(docker ps -a -q); docker rmi $(docker images -q)'
alias dkrrebuild='cd $WORK_PROJECTS/ci/webapi; docker build --no-cache -f Dockerfile -t dimensional/webapi ..'
alias dkrwebapidevelop='sudo docker-compose -f $WORK_PROJECTS/ci/webapi/docker-compose.yml run -p 99:99 webapi_develop'
alias dkrwebapidevelopnopip='sudo docker-compose -f $WORK_PROJECTS/ci/webapi/docker-compose.yml run -e "SKIP_PIP=yes" -p 99:99 webapi_develop'
alias dkrwebapiserver='docker-compose -f $WORK_PROJECTS/ci/webapi/docker-compose.yml up webapi_server'
alias dkrredowebapi='dkrremoveall; dkrrebuild; dkrwebapidevelop'
# END


# SERVICES*
if [ "$(uname)" == "Darwin" ]; then
    SERVICE_COMMAND='brew services'
    mystart() { $SERVICE_COMMAND start $1 ;}
    myrestart() { $SERVICE_COMMAND restart $1 ;}
    mystop() { $SERVICE_COMMAND stop $1 ;}
    alias start='brew services start $1'
    alias restart='brew services restart $1'
    alias stop='brew services stop $1'
 else
    SERVICE_COMMAND='sudo service'
    mystart() { $SERVICE_COMMAND $1 start ;}
    myrestart() { $SERVICE_COMMAND $1 restart ;}
    mystop() { $SERVICE_COMMAND $1 stop ;}
    alias start='sudo service $1 start'
    alias restart='sudo service $1 restart'
    alias stop='sudo service $1 stop'
fi
# END


# MPOS*
alias mpos="$MPOS_SCRIPTS_PATH/mouseposition.py"
MPOS_SILO_PATH="$MPOS_SCRIPTS_PATH/mousepositionsilo.sh"
alias mposclear='echo -e "#!/bin/bash\n\n" > $MPOS_SILO_PATH'
alias mposrun='aps $MPOS_SILO_PATH; $MPOS_SILO_PATH'
# END


# C*
compile() { cc -std=c99 -Wall $1 -o $2 ;}
remakec() { rm $1; make $1 ;}
# END


# http://stackoverflow.com/questions/32205052/bash-cat-all-files-that-contains-a-certain-string-in-file-name
#cat `find -name "*gitignore*"` > codytest.txt


# UPDATES*
# ...see scripts/setup_scripts/general/three-clone_projects_configure_git_setup_cronjobs.py
alias pushfiles='$UPDATES_SCRIPTS_PATH/update_files.py push'
alias pullfiles='$UPDATES_SCRIPTS_PATH/update_files.py pull'
alias updateall='$UPDATES_SCRIPTS_PATH/pull_and_update_all_projects.py'
# END


# PYTHON*
alias setupnstl='python setup.py install'
alias setupdev='python setup.py develop'
alias unittest='python -m unittest discover $@'
# END


# PIP/VENVs*
alias pipinstall='pip3 install -r requirements.txt'
alias pip2install='pip install -r requirements.txt'
alias pipfrz='pip3 freeze'
alias pip2frz='pip freeze'
# this script will also add machine packages, very bad. need to diff sudo pip installed machine packages vs venv packages
# alias pipupdate='$UPDATES_SCRIPTS_PATH/update_pip_requirements.py'

# http://mrcoles.com/tips-using-pip-virtualenv-virtualenvwrapper/
mymkvirtualenv() {
    echo "making python3 venv"
    deactivate;
    mkvirtualenv -p `which python3` `basename "$PWD"`;
    pwd > ~/.virtualenvs/$(basename "$PWD")/.project; # does same thing as setvirtualenvproject
    pipinstall;
}
venvreset() { deactivate; rmvirtualenv $1; mkvirtualenv $1 ;}
nstlpip() { pip install $@ ;}

alias myrmvirtualenv='deactivate; rmvirtualenv $1'
# END


# GIT*
alias st='git status'
alias master='git co master'
alias dev='git co develop'
alias dif='git diff'
alias reset='git reset --hard HEAD'
alias difcached='git diff --cached'
alias difrecent='git diff HEAD^..HEAD'
alias addall='git add -A'
alias co='git checkout $1'
alias push='git push'
alias pushupstream='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias pull='git pull'
alias pushall='git add -A; git commit -m "autoupdate"; git push'
alias cleargit='rm -rf .git .gitignore'
alias showorigin='git remote show origin'
init() { $GIT_SCRIPTS_PATH/git_init_new_repo.py ;}
# https://git-blame.blogspot.com/2013/06/checking-current-branch-programatically.html
alias initialpush='git push -u origin $(git symbolic-ref --short -q HEAD)'
alias cloneall='$GIT_SCRIPTS_PATH'
alias deleterepo='$GIT_SCRIPTS_PATH/mygit.py delete $1'
dltbranch() {
    git push origin --delete $1
    git push upstream --delete $1
    git branch -D $1
}
dlttag() {
    # http://www.manikrathee.com/how-to-delete-a-tag-in-git.html
    git tag -d $1
    git push origin :refs/tags/$1
}
cmpush() { git cm "$1"; git push ;}
cmpushall() { git add -A; git cm "$1"; git push ;}
clone() {
    git clone git@bitbucket.org:codyc54321/$1.git
    mkvirtualenv -p `which python3` $1
    cd $1
    pip3 install -r requirements.txt
    python3 manage.py makemigrations
    python3 manage.py migrate
    port 8199
}
# END

# GITFLOW*
# github/pivotal tracker management
GITFLOW_AUTOMATION_PATH="$PROJECTS/gitflow_automation"
GITFLOW_AUTOMATION_SCRIPTS="$GITFLOW_AUTOMATION_PATH/scripts"

export PYTHONPATH="${PYTHONPATH}:$GITFLOW_AUTOMATION_PATH"

alias gitflowopenpullrequest="$GITFLOW_AUTOMATION_SCRIPTS/open_pull_request.sh"
alias gitflowmakestory="$GITFLOW_AUTOMATION_SCRIPTS/make_stories.sh"
alias gitflowmakereleasestory="$GITFLOW_AUTOMATION_SCRIPTS/make_release_story.py"
alias gitflowbackupallbranches="$GITFLOW_AUTOMATION_SCRIPTS/backup_all_branches.sh"

dltbranch() {
    git push origin --delete $1
    git push upstream --delete $1
    git branch -D $1
}

backup_branch() {
    git checkout $1
    backup_branch="backup__$1"
    git checkout -b $backup_branch
    git push -u origin $backup_branch
    dltbranch $1
}

reset_branch() {
    the_new_current_branch="$(git branch | grep '\* ' | sed 's/^.*\( .*\)/\1/g')"
    if [ ! $the_new_current_branch = $1 ]; then
        git checkout $1
    fi
}

branch_is_protected(){
    if [[ "$1" == dev* || "$1" == "master" || "$1" == backup* ]]
    then
        echo "true"
        # exit 1
    else
        echo "false"
        # exit 0
    fi
}
# END

# CRAIGSLIST*

CRAIGSLIST_SCRIPTS_PATH="$HOME/scripts/ez_scrip_lib/crugs_list/scripts"

alias craigslistcablespost="$CRAIGSLIST_SCRIPTS_PATH/post_fiber_optic_cables_ad.py"
alias craigslistroompost="$CRAIGSLIST_SCRIPTS_PATH/post_room_rental_ads.py"


# DJANGO*
alias shl='python3 manage.py shell_plus --ipython'
# make bash function to find the current IP, then pass it to python3 manage.py runserver to run publically. remember, IPv6 isnt working...
alias rspublic='python3 manage.py runserver 0.0.0.0:8000'
alias shl2='python manage.py shell_plus --ipython'
alias rs='python3 manage.py runserver'
alias rs2='python manage.py runserver'
port() { fuser -k $1/tcp; python manage.py runserver $1 ;}
registerapps() { $DJANGO_SCRIPTS_PATH/register_apps.py "$@" ;}
startapp() { $DJANGO_SCRIPTS_PATH/admin/startapp.py "$@" ;}
startproject() { $DJANGO_SCRIPTS_PATH/admin/startproject.py "$@" ;}
modelform() { $DJANGO_SCRIPTS_PATH/models_to_modelform.py ;}
cleanproject() { $DJANGO_SCRIPTS_PATH/clean_project_of_ugly_files.py "$@" ;}
skiptests() { $UNITTESTS_SCRIPTS_PATH/skip_unittests.py "$@" ;} # this is useless since you should call tests by name
mpy() { ./manage.py "$1" ;}
alias testthis='$DJANGO_SCRIPTS_PATH/test_this.py'
# END


#http://serverfalias up='cd ..; pwd; ls'ault.com/questions/241588/how-to-automate-ssh-login-with-password
#for each machine, call ssh-copy-id user@hostname, as in:
#    ssh-copy-id root@104.131.172.138
#now it has your public key and you can login without password from that machine


# APT-GET*
# http://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux
if [ "$(uname)" == "Darwin" ]; then
    : # : means "do nothing", like "pass"
    alias upd='brew update'
    # https://sanctum.geek.nz/arabesque/testing-exit-values-bash/
    nstl() {
        if ! brew install $@; then # if not brew install $@ worked, then try cask
            brew cask install $@
        fi
    }
    rmv() { brew remove $@ ;}
    alias search='brew search $1'
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then # check if linux
    alias upd='echo $THE_USUAL | sudo -S apt-get update'
    nstl() { echo $THE_USUAL | sudo -S apt-get install -y $@ ;}
    rmv()  { echo $THE_USUAL | sudo -S apt-get remove -y $@ ;}
    purge() { echo $THE_USUAL | sudo -S apt-get purge -y $@ ;}
    autoremove() { echo $THE_USUAL | sudo -S apt-get autoremove -y ;}
fi
# END


# CODE META*
printrmv() { $PYCOMPLETE/printremove.py "$@" ;}
pretty() { $PYCOMPLETE/pretty_spacing.py "$@" ;}
alias npy='$CODE_META_SCRIPTS_PATH/newpy.sh'
alias nru='$CODE_META_SCRIPTS_PATH/newruby.sh'
alias nsh='$CODE_META_SCRIPTS_PATH/newshell.sh'
alias astplay='$AST_SCRIPTS_PATH/astplay.py'
# END


# TEMP*

# END

function git_dirty {
    text=$(git status)
    changed_text="Changes to be committed"
    changes_not_staged="Changes not staged for commit"
    # untracked_files="Untracked files"  ignore this: || ${text} = *"$untracked_files"* because untracked files could pertain to other branches

    dirty=false

    if [[ ${text} = *"$changed_text"* ||  ${text} = *"$changes_not_staged"* ]]; then
        dirty=true
    fi

    echo $dirty
}

function get_current_branch {
    git_cruft="refs\/heads\/"
    # http://stackoverflow.com/questions/1593051/how-to-programmatically-determine-the-current-checked-out-git-branch
    branch_name="$(git symbolic-ref HEAD 2>/dev/null)"
    # http://stackoverflow.com/questions/13210880/replace-one-substring-for-another-string-in-shell-script
    final_branch_name="${branch_name/$git_cruft/}"
    echo $final_branch_name
}

alias updatebranch='git pull upstream develop'

# TRILOGY

# END

# UDEMY*
alias cdudemy='cd ~/tutorials/javascript/react/udemy-react-redux-course'
# END


if [ "$(uname)" == "Darwin" ]; then
    . $HOME/.bashrc
    . $HOME/.bash_prompt
    # . $HOME/.bash_prompt2
    # check .bashrc to see what .passwords_and_usernames looks like (never send passwords over the net)
    . $HOME/.passwords_and_usernames
    alias src='source ~/.bash_profile'
    # run this command on mac to ensure the docker-machine runs in each terminal
    # eval $(docker-machine env default)
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    alias src='source ~/.bashrc'
fi


# https://github.com/candrholdings/slack-cli
# sending files is broken...
# you can send files like:
#    curl -F file=@$FILENAME -F channels=general -F token=$SLACK_TOKEN https://slack.com/api/files.upload
export SLACK_TOKEN="xoxp-159539740338-160220914038-166569246215-d2a0c34941b772211e1b69d53c093776"
# export slacker="/Users/cchilders/projects/trilogy_TA_class/lesson-plans/slacker/slacker.py"
export slacker="/Users/cchilders/projects/trilogy_TA_class/supporting-scripts-trilogy/slacker/slacker.py"
alias slacker='$slacker'
