# Local Development 

开发的时候需要启动众多服务进程

rails 服务器 
webpacker 本地开发时实时编译静态资源 
postgres 服务 
redis 服务 
sidekiq 处理任务队列 
ngrok 反向代理，微信本地开发必须要用域名，不能用localhost或127.0.0.1 
odoo (odoo 也依赖postgres db) 最好用docker来启动封装好的image 

注意: 
1. postgres, redis 可以用本地的（即用brew services start xxx），也可以用docker容器， 无论是用哪种方式启动, 如果出错记得修改配置文件连接信息

2. 因为本项目模块众多，所以本地开发环境下引入了foreman，以便一次启动多个服务（Profile）


# Deploy to staging/production 

in favor of kubernetes, capistrano deprecated  

需要注意的是: 
微信授权的时候获取access_token有个ip白名单需要配置（微信测试号不需要设置ip白名单，但是线上必须要，如果授权什么的失败，要想到可能是ip白名单出问题了）
但是心累的时候获取access_token的时候，微信返回的信息显示这个ip不是LoadBalancer的ip，而是pod，
而pod是无状态的，ip易变的，容易导致获取access_token失败，必须要经常去微信管理后台配置ip白名单
所以最好把获取access_token的动作抽取成为微服务，中控服务器一经启动 不需要再在部署的时候频繁重启导致ip变化，白名单设置失效
