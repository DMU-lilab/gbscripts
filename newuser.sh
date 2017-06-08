#/bin/bash
usage(){
	echo "usage: `basename $0` username"
}

myhash(){
        hashsum=0
        seed=66

        for (( i=1; i<= 10; i++ ))
        do
                username=${username}$1
        done

        for (( i=1; i<= `expr length ${username}`; i++ ))
        do
                chr=`expr substr ${username} ${i} 1`
                val=`echo -n ${chr} | od -An -td`
                hashsum=`expr ${hashsum} \*  ${seed} + ${val}`
        done

        echo `expr ${hashsum} % 65535`
}

newuser(){
	user=$1
	gid=$2
	uid=`myhash ${user}`

	if [ -n "`cat /etc/passwd | grep -e ".*:.*:.*:${gid}:.*" | cut -f 3 -d : | grep ${uid}`" ];then
		echo "user ${user}:${uid} exists!"
		exit -1
	fi
	
	useradd -u ${uid} -g ${gid} ${user}
	echo ${user}"123" | passwd --stdin ${user}
	if [ -d "/home/${user}" ];then
		chmod g+x /home/${user}
	fi
}

if [ $# != 1 ];then
	usage
	exit -1
fi

groupid=`cat /etc/group | grep ^lilab | tail -1 | cut -f3 -d:`

newuser $1 ${groupid}
chage -d 0 -M 365 -W 15 $1

trackdir="/home/trackdir/$1"
mkdir -p ${trackdir}
chown $1:lilab ${trackdir}

ln -s ${trackdir} /home/$1/track
