# !/bin/bash
#add fix to exercise6-fix here

# Steps:
#  1. Check where you sould copy the files
#  2. Check argument are valide: 
        # at least 2 args 
        # all files exists  
        # dirctory is exsists -> if not create it 
#  3. Copy the files....

check_remote_dir() {
        printf "\ntesting remote directory: '$1' \n"
        # $1 = Server name  , $2 = directory name 
        if ssh "$1" "[ ! -d $2 ]"; then
                printf "\nCreating: $1 on $1\n"
                ssh "$1" "mkdir -p $2"
        else
                printf "[OK]\n"
        fi
}

set_destantion(){
    hs=$HOSTNAME
    if [ $hs = "server1" ]; then
    echo "server2"
    elif  [ $hs = "server2" ]; then
    echo "server1"
    else
    echo "ERROR NOT RUNNINT ON SERVER"
    fi
}


# 1) Check number of arguments is Valid
echo "The number of arguments is: $#"
if  (($# < 2)) ; then
    echo "Illegal number of parameters"
    exit
fi

# 2) Set the destantion server
SERVER_DEST=$(set_destantion) 

# 3) Get the destenation file and check if exciting: TRUE - Return , FALSE - Create the file
DIR_DEST="${!#}"
check_remote_dir $SERVER_DEST $DIR_DEST 
sleep 1



# 4) Check arguments are valide:
        # Check that file exists: TRUE - copy the file, FALSE - Skip file 
        # Sum the sizeof file
echo "start loop:"
SIZE=0
for file in ${@:1:$#-1}; do

        if [ -f "$file" ]; then
            scp -qi  /home/vagrant/.ssh/id_rsa $file $SERVER_DEST:$DIR_DEST
            SIZE=$((${SIZE}+$(du -b $file | awk '{ print $1 }')))
        else
            echo "$file: NOT A FILE! "
        fi
done

echo $SIZE
