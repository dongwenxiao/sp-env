# 
# super_project app 自动部署脚本
# 1.把app源码文件名改为app
# 2.把app文件夹压缩成app.zip	
# 3.把app.zip防止到files文件夹中
# 
# 上传到服务器后，准备执行的命令
# sh -x deplay.app.sh [域名:abc.com] [端口:3000]


# superproject
# super_project_path='/data/apps'

# app
app_domain=$1 #'daibanshenqi.com'
app_port=$2
# app_path="${super_project_path}/apps/${app_domain}"

# nginx
nginx_config_path='/etc/nginx/conf.d'


# function app_deploy(){
# 	unzip ./files/app.zip
# 	mv ./app ${app_path}
# 	cd ${app_path} && cnpm i
# }

function nginx_config_deplay(){
	cp -r ./files/nginx.app.conf ${nginx_config_path}/${app_domain}.conf
	sed -i "s/domain/$app_domain/g"  ${nginx_config_path}/${app_domain}.conf
	sed -i "s/3000/$app_port/g"  ${nginx_config_path}/${app_domain}.conf
}

function nginx_reload(){
	mkdir -p /data/logs/www.ttlearning.com.cn/
	/etc/init.d/nginx reload
}


# run
if [[ -n ${app_domain}  && -n ${app_port}  ]]; then
	nginx_config_deplay
	# app_deploy
	nginx_reload
else 
	echo 'Fail, app_domain and app_port must be input!'
fi