#!/bin/bash

echo [INFO] "正在更新源代码..."
cd /opt/src/portal/
git pull
git reset --hard

echo [INFO] "正在编译项目..."
mvn clean package -Dmaven.test.skip=true

echo [INFO] "正在部署..."
cp -rf ./target/portal.war /opt/webapps/portal/ROOT.war

echo [INFO] "正在重置 jetty 服务器..."
/opt/conf/jetty/portal/jetty.sh restart

echo [INFO] "操作完成！"
