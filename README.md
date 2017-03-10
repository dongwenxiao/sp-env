# sp-env
Linux sp-* environment.

在 Linux （CentOS 6.x）系统上安装 super-proejct 环境，所需要的安装包和自动化shell脚本。

## 安装包含

* yum 常用工具包
* nginx
* git
* nodejs \ npm
* pm2 \ Yarn
* mongodb

## 自动配置
* nginx
* 各种logs


## nginx 添加配置

```
sh -x 3_nginx-add.sh [域名:abc.com] [端口:3000]
```

## 基础文件

files 文件是安装需要的基础文件

## 使用

```
# 1 在shell里执行（1_ready.sh）内容

# 2 上次文件包
cd /data/env/files && rz [files里面的各个文件]

# 3 files文件夹上传后，回到上一级目录执行 2_install.sh
cd .. && sh -x 2_install.sh


# 4 如果需要配置nginx,执行脚本3并加上参数即可
sh -x 3_nginx-add.sh [域名:abc.com] [端口:3000]
```

