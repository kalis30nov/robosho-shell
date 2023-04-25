script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

component=user
func_nodejs()

cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y
mongo --host mogodb-dev.kalis30nov.online </app/schema/user.js