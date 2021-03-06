#!/bin/bash
###### I needed a script which checks in every directory if the current version
###### is the latest in tags direcktory in svn

SRC=

usage()
{
    cat <<EOF
    usage: $0 options

    This script will tell you if your svn subdirectories need an update. 

    OPTIONS:
    -d  Root directory to check for svn sub folders
    -h  Show this message
EOF
}

while getopts “hd:” OPTION
do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        d)
            SRC=$OPTARG
            ;;
        ?)
            usage
            exit
            ;;
    esac
done

if [[ -z $SRC ]]
then
    usage
    exit 1
fi

cd $SRC
for dir in `ls`
do
    if [[ -d $dir ]]; then
        cd $dir
        svn info &> /dev/null
        if [[ $? -eq 0 ]]; then 
            SVN_CURRENT=`svn info | sed -n 2p | cut -d ' ' -f 2 | sed 's_http:/__g' | awk -F "/" '{print $NF}'`
            SVN_URL=`svn info | sed -n 3p | cut -d ' ' -f 3`
            SVN_LATEST=`svn ls $SVN_URL/${PWD##*/}/tags | sed "s_/__g" |  sort -but. -k1,1 -k2,2n -k3,3n -k4,4n -k5,5n | tail -n 1`
            if [[ -n $SVN_CURRENT ]] && [[ -n $SVN_LATEST ]] && [[ $SVN_LATEST != $SVN_CURRENT ]]; then
                echo "$dir need an update! Current: $SVN_CURRENT Newest: $SVN_LATEST"
                echo "=> Please go to $SRC/$dir and do: svn switch $SVN_URL/$dir/tags/$SVN_LATEST"
            fi
        fi
        cd .. 
    fi
done
