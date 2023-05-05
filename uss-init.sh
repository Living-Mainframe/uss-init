#!/usr/bin/env sh

# Shell script to set up a new USS environment.
# Copyright (C) 2023  Dorian Zimmer,
#                     Living Mainframe (https://living-mainframe.de)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


help(){
	# print help
    echo "usage: $0 [commands]"
    echo
    echo "available commands:"
    echo " bashrc   create and tag ~/.bashrc"
    echo " aliases  add unicode u* aliases"
    echo " clear    add clear as an alias and as ^L"
    echo " exports  add common environment variables to ~/.profile"
    echo " git      enhance the shell prompt to show the current git branch of git managed directories"

}

check_bash(){
	# check if bash is available
    bash -c "" || (echo "bash doesn't seem to be installed"; return 1)
}

init_bashrc(){
	# create and tag ~/.bashrc
	if [ -f ~/.bashrc ]; then
		echo "$HOME/.bashrc already exists"
	else
		echo "creating $HOME/.bashrc"
		touch ~/.bashrc
	fi
	chtag -t -c ISO8859-1 ~/.bashrc
}

add_git_branch(){
	# add prompt-built-in branch info to ~/.bashrc
	echo "adding prompt-built-in branch info to $HOME/.bashrc"
	grep "^export PS1" ~/.bashrc > /dev/null ||
		cat <<EOT >> ~/.bashrc
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
EOT
}     

add_u_aliases(){
	# add unicode aliases to ~/.bashrc
	echo "adding u* aliases to $HOME/.bashrc"

	grep "^alias ucat=" ~/.bashrc > /dev/null ||
		echo 'alias ucat="cat -Wfilecodeset=UTF8"' >> ~/.bashrc
	grep "^alias ugrep=" ~/.bashrc > /dev/null ||
		echo 'alias ugrep="grep -Wfilecodeset=UTF8"' >> ~/.bashrc
	grep "^alias uvi=" ~/.bashrc > /dev/null ||
		echo 'alias uvi="vi -Wfilecodeset=UTF8"' >> ~/.bashrc
}

add_clear(){
	# add clear as an alias and as ^L to ~/.inputrc
	grep "^alias clear=" ~/.bashrc > /dev/null || (
		echo "adding clear to $HOME/.bashrc"
		echo "alias clear='printf \"\\033[2J\\033[1;1H\"'" >> ~/.bashrc
	)

	grep "^C-L:" ~/.inputrc > /dev/null || (
			echo "adding C-L as clear to $HOME/.inputrc"
			printf 'C-L: "clear\\n"\n' >> ~/.inputrc
        )
}

add_exports(){
	# add common environment variables to ~/.profile
	echo "adding environment variables to $HOME/.profile"

	grep "^export _BPXK_AUTOCVT=" ||
		echo 'export _BPXK_AUTOCVT=ON' >> ~/.profile
	# shellcheck disable=SC2016
	grep "^export _CEE_RUNOPTS=" ||
                echo 'export _CEE_RUNOPTS="$_CEE_RUNOPTS FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"' >> ~/.profile
	grep "^export _TAG_REDIR_ERR=" ||
                echo 'export _TAG_REDIR_ERR=txt' >> ~/.profile
	grep "^export _TAG_REDIR_IN=" ||
                echo 'export _TAG_REDIR_IN=txt' >> ~/.profile
	grep "^export _TAG_REDIR_OUT=" ||
                echo 'export _TAG_REDIR_OUT=txt' >> ~/.profile
}

check_bash || exit 1
[ "$#" -eq 0 ] && help

while true; do
	case "$1" in
                "bashrc") init_bashrc;;
                "aliases") add_u_aliases;;
                "clear") add_clear;;
 		"git") add_git_branch;;
 		"exports") add_exports;;
		"") exit 0;;
		*) echo "unknown option: $1";;
	esac
	shift
done
