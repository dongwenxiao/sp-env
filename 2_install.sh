# Cent OS 6.* 自动部署脚本

# 环境目录结构
# /data/apps/
# /data/mongodb
# /data/logs
# /data/logs/mongodb/
# /data/logs/nginx/
# /data/logs/nodejs/


# 系统版本
sys_var=`head -n1 /etc/issue | awk  '{print $3}'| awk -F'.' '{print $1}'`

# 软件安装目录
install_path='/usr/local'
script_run_path=`pwd`

# all log
log_path='/data/logs'

# mongo
mongo_ip='127.0.0.1'
mongod_port='27017'
mongod_db_path='/data/mongodb'
mongod_log_path=$log_path'/mongodb/logs'

# superproject
# super_project_path='/data/super_project'

# mongod --dbpath=/data/mongodb --port=27017 --logpath=/mongodb/logs/mongo.log --bind_ip=127.0.0.1 --fork


####################################################################

ready_pah(){
	# yum 源备份
	mkdir -p /etc/yum.repos.d/back

	# mongodb
	mkdir -p $mongod_db_path 
	mkdir -p $mongod_log_path 

    # apps
    mkdir -p /data/apps

}

yum_update(){
	# mkdir -p /etc/yum.repos.d/back
	# mv /etc/yum.repos.d/* /etc/yum.repos.d/back
	rpm -ivh ./files/epel-release-6-8.noarch.rpm

	yum clean all
}

yum_install_software(){
	yum -y install \
	gcc make gcc-c++ openssl-devel wget lrzsz zip unzip \
	perl-ExtUtils-MakeMaker package tcl build-essential tk gettext asciidoc asciidoc-devel \
	xmlto xmlto-devel curl-devel autoconf nginx
}

# nginx_install(){
# 	yum -y install nginx
# }


nodejs_install(){
	# tar --strip-components 1 -xzvf ./files/node-v*.tar.gz  
	curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
	yum -y install nodejs
}

nodejs_modules_install(){
	# 国内适合cnpm
	npm i cnpm -g
	# yarn 安装
	cnpm i -g yarn
	# pm2 管理安装
	cnpm i pm2 -g
	# 版本切换
	cnpm i n -g
	n 7.1.0
}

# nodejs_project_deploy(){
# 	echo 'aaaa'
# }

git_install(){
	tar -zxvf ./files/git-1.9.0.tar.gz
	cd ./git-1.9.0/ && make configure && ./configure --prefix=$install_path/git/ 
	make && make install
	ln -s $install_path/git/bin/git /usr/bin/git
}

mongodb_install(){
	cd $script_run_path
	# mkdir -p $mongod_db_path 
	# mkdir -p $mongod_log_path 
	
	tar -zxvf ./files/mongodb-linux-x86_64-rhel62-3.2.10.tgz -C $install_path/
	mv $install_path/mongodb-linux-x86_64-rhel62-3.2.10 $install_path/mongodb
	ln -s $install_path/mongodb/bin/mongo /usr/bin/mongo
	ln -s $install_path/mongodb/bin/mongod /usr/bin/mongod
	ln -s $install_path/mongodb/bin/mongodump /usr/bin/mongodump
	ln -s $install_path/mongodb/bin/mongorestore /usr/bin/mongorestore

}

# super_project_deploy(){
# 	unzip ./files/super_project.zip
# 	mv ./super_project.git $super_project_path
# 	cd $super_project_path && cnpm i
# }


start_service(){
	# mongod
	mongod --dbpath=$mongod_db_path --port=$mongod_port --logpath=$mongod_log_path/mongo.log --bind_ip=$mongo_ip --fork

	# nginx
	/etc/init.d/nginx restart

}

centOS6x(){
	ready_pah
	yum_update
	yum_install_software
	git_install
	mongodb_install
	nodejs_install
	nodejs_modules_install
	# nginx_install
	#yarn_install
	start_service
	#super_project_deploy
}



if [ $sys_var == '6' ];then
	centOS6x
else
	echo 'Only support CentOS 6.x ,now!' 

fi
