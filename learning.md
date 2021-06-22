# addgroup

    addgroup [-g GID] [-S] [USER] GROUP

`addgroup` 一般情况下创建用户的同时会创建组，包括其ID号

-g GID：用户组GID

-S：创建系统组

# adduser

    adduser [OPTIONS] USER [GROUP]

`adduser` 创建新用户或将用户添加到组

-h DIR：创建用户时指定用户家目录位置，默认/home/NAME

-g GECOS：用户备注信息，即/etc/passwd第五个字段

-s SHELL：指定用户所使用的shell，默认/bin/ash

-G GRP：指定用户所属的组

-S：创建系统用户，创建系统用户时不自动创建组，默认情况下创建用户时会同时创建一个与账号同名的组

-D：创建用户时不创建密码

-H：创建用户时不创建用户家目录

-u UID：指定用户UID

-k SKEL：指定骨骼框架目录位置，默认/etc/skel，其实就是用来放置新用户配置文件的，添加一个新用户时，会将该框架目录中的文件复制到新用户的家目录下。

# Bash Reference
  [Bash](https://www.gnu.org/software/bash/manual/bash.html)
  