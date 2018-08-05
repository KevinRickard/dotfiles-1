# Enable tab completion
#source ~/dotfiles/git-completion.bash

# colors!
green="\[\033[0;32m\]"
cyan="\[\033[0;36m\]"
red="\[\033[0;91m\]"
reset="\[\033[0m\]"

# Change command prompt
source ~/dotfiles/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
# '\u' adds the name of the current user to the prompt
# '\$(__git_ps1)' adds git-related stuff
# '\W' adds the name of the current directory
export PS1="$red\u$green\$(__git_ps1)$cyan \W $ $reset"

export ANDROID_SDK_ROOT=/usr/local/share/android-sdk

# Giving priority to gnu updated coreutils from brew install coreutils
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

alias l='ls -lh'
alias la='ls -lah'
alias vi='vim'
alias g='git status'
alias gc='git commit -m'
alias v='vim'

copy(){
    test -z $1 && echo "No file input!" && return
    test ! -e $1 && echo "File not exist!" && return
    export orig_path="$PWD/$1"
    export orig_name="$1"
}
paste(){
    test -z $orig_path && echo "No copied file!" && return
    if [ "$#" -lt 1 ];then
        dist_name="$PWD/$orig_name"
        if [ -d $orig_path ];then
            cp -r $orig_path $dist_name
        else
            cp $orig_path $dist_name
        fi
        echo "$orig_name pasted."
    else
        dist_name="$PWD/$1"
        if [ -d $orig_path ];then
            cp -r $orig_path $dist_name
        else
            cp $orig_path $dist_name
        fi
        echo "\"$1\" pasted."
    fi
}

###############################################################################
# Refaults
###############################################################################

REFAULTS_DIR="$HOME/.refaults"
DEFAULTS_READ_FILE="$REFAULTS_DIR/defaults_read"
refaults(){
    if [ ! -f $DEFAULTS_READ_FILE ] && [ ! -d "$REFAULTS_DIR/.git" ];then
        echo "Creating refaults directory: $REFAULTS_DIR"
        mkdir -p $REFAULTS_DIR
        echo "Creating defaults read file: $DEFAULTS_READ_FILE"
        defaults read > $DEFAULTS_READ_FILE
        echo "Creating refaults directory: $REFAULTS_DIR"
        echo "Creating git repository for refaults:"
        git -C $REFAULTS_DIR init
        git -C $REFAULTS_DIR add $DEFAULTS_READ_FILE
        git -C $REFAULTS_DIR commit -am "Initial Defaults"
    else
        if [ $# == 0 ];then
            refaults diff
        else
            if [ $1 == "commit" ];then
                commit_msg="Update Defaults"
                if (( $# >= 2 ));then
                    commit_msg=$2
                fi
                git -C $REFAULTS_DIR commit -am "$commit_msg"
            else  
                if [ $1 == "diff" ];then
                    echo "Reading defaults current state."
                    defaults read > $DEFAULTS_READ_FILE
                    commits_back="0"
                    if (( $# >= 2 ));then
                        regex_for_num='^[0-9]+$'
                        if ! [[ $2 =~ $regex_for_num ]];then
                            echo "ERROR: second argument is not a number. Defaulting to last commit"
                        else
                            commits_back=$2
                        fi
                    fi
                    echo "Comparing to $commits_back commits back:"
                    git -C $REFAULTS_DIR diff HEAD~$commits_back
                    echo "If you want to save this state, don't forget to make a 'refaults commit'!"
                else
                    if [ $1 == "log" ];then
                        git -C $REFAULTS_DIR log
                    else
                        if [ $1 == "status" ];then
                            defaults read > $DEFAULTS_READ_FILE
                            git -C $REFAULTS_DIR status
                        fi
                    fi
                fi
            fi
        fi
    fi
}
