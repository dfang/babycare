#! /bin/bash

docker-compose down -v

# docker volume create --name=odoo-web-data
# docker volume create --name=odoo-db-data

# 启动服务
docker-compose up --build --force-recreate -d
# docker-compose up -d

# 初始化rails 数据库
docker exec -ti -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 babycare_app_1 bin/rails db:setup

# 初始化odoo 数据库
docker exec -ti odoo python /tmp/bootstrap_odoo_db.py

# 查看babycare容器日志
# docker logs -f babycare