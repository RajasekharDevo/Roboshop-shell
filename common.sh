app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head(){
  echo -e "\e[36m >>>>>>>> $* <<<<<<<<<<<<\e[0m"
}

schema_setup(){
 if [ "$ schema_setup" == "mongo" ] ; then
   print_head "Copy MongoDB repo"
   cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

   print_head Install  "MongoDB Client"
   dnf install mongodb-org-shell -y

   print_head "Load Schema "
   mongo --host mongodb-dev.rajasekhar72.store </app/schema/${component}
 fi
}

func_nodejs(){

print_head  "configuring nodejs  repos"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -

print_head  "Install Nodejs  repos"
dnf install nodejs -y

print_head  "Add  Application User"
useradd roboshop

print_head  "Created Application  Directory"
rm -rf /app
mkdir /app

print_head  "Download  App  Content"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app

print_head  "Unzip App  Content"
unzip /tmp/${component}.zip

print_head  "Install   NodeJS  Dependencies"
npm install

print_head "Application Directory"
cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

print_head "Start"
systemctl daemon-reload
systemctl enable ${component}
systemctl restart ${component} ; tail /var/log/messages

schema_setup

}