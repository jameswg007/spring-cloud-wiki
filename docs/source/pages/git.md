########################
初识 Git
########################

常见Git命令
===============
::

    克隆和下载项目： git clone https://github.com/LiMeii/angular-seed-project.git
    提交代码： git push -u origin master / git push
    设置用户名密码： git config –global user.name “Your Name”
    设置用户邮箱： git config –global user.email you@example.com
    SSL Certificate problem: unable to get local issuer certificate： 解决方案 git config –global http.sslVerify false
    查看文件列表: ls
    查看隐藏文件：ls -al
    查看Git状态：git status / git status -s
    查看Git提交历史：git log
    添加所有改动文件到暂存区（工作区到暂存区）：git add .
    添加某个改动文件到暂存区（工作区到暂存区）：git add 文件名
    提交改动文件到版本库（从暂存区到版本库）：git commit -m “comments”
    提交改动文件到版本库（直接从工作区到版本库）：git commit -a -m “comments”
    工作区和暂存区比较：git diff
    工作区和版本库比较：git diff 分支名
    暂存区和版本库比较：git diff –cached
    取消本地目录下关联的远程库：git remote remove origin
    撤销所有操作（暂存区覆盖工作区，放弃当前工作区修改内容）：git checkout .
    撤销某个文件操作（暂存区覆盖工作区，放弃当前工作区修改内容）：git checkout 文件名
    当不小心把当前工作区错误提交到暂存区，回滚到上一个暂存区：git reset HEAD 文件名
    查看所有的版本号：git reflog
    按版本号回滚版本：git reset –hard 版本号
    回退到上一个版本：git reset –hard HEAD^
    回退某一个版本的文件到工作区：git checkout 版本号 文件名
    查看分支：git branch
    创建分支：git branch 分支名
    切换分支：git checkout 分支名
    创建并切换分支：git checkout -b 分支名
    删除分支（需要切换出要删除的分支）：git branch -D 分支名
    暂存更改：git stash
    还原暂存的内容：git stash pop
    合并分支（将指定分支合并到当前所在的分支，需要先切换到当前分支，比如master主分支）：git merge 指定的分支名
    把某一个commit合并回主分支（需要先切换到主分支）：git cherry-pick 99daed2(commitID)
    推送代码到远程仓库：git push origin master
    推送代码到远程仓库（以后再次提交的时候可以省略地址别名和分支名称，直接用命令git push进行提交）：git push -u origin master
    拉取最新代码但是不合并代码：git fetch origin master
    拉取最新代码并且合并代码：git pull origin master
    拉取别人的项目到本地：git clone 项目地址 项目名
    初始化Git仓库：git init
    查看配置信息：git config –list
    创建文件：touch 文件名
    移动文件：mv 文件/文件夹 路径
    查看文件内容：cat 文件名
    删除文件/文件夹：rm 文件名
    创建文件夹：mkdir 文件夹名
    查看URL地址： git remote -v
    删除.git文件: find . -name “.git” | xargs rm -Rf
    echo 'token.mat' >> .gitignore

Connecting with SSH
========================
https://help.github.com/cn/enterprise/2.16/user/authenticating-to-github/connecting-to-github-with-ssh

RPC
========
RPC(remote procedure call)

Web
*******
https://bottlepy.org/docs/dev/tutorial.html#

::

    import subprocess
    from bottle import run, post, request, response, get, route, abort, error


    @route('/<path>', method='POST')
    def process(path):
        p = subprocess.Popen(
            ['python',  path+'.py'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        output, errors = p.communicate()
        if errors:
            return errors
        return output

    @route('/<command>/<file>', method='POST')
    def processcommand(command, file):
        p = subprocess.Popen(
            [command,  file], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        output, errors = p.communicate()
        if errors:
            return errors
        return output

    @route('/restricted')
    def restricted():
        abort(401, "Sorry, access denied.")


    @error(404)
    def error404(error):
        return 'Nothing here, sorry'


    run(host='localhost', port=8080, debug=True)


SSH
***************
SSH tip: Send commands remotely

::

    ssh-keygen -t rsa // 生成密钥
    ssh-copy-id -i ~/.ssh/id_rsa.pub root@9.111.98.177
    ssh root@9.111.98.177 "/work/shell.sh"

API
============
https://api.github.com/