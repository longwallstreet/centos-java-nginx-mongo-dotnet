FROM centos

RUN mkdir -p /opt/devops/ 

# 1. install java online
RUN yum -y update && yum install -y java-1.8.0-openjdk-1.8.0.212.b04-0.el7_6 

# 2. install dotnet 2.1 online
RUN rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm \
	&& yum -y update && yum -y install aspnetcore-runtime-2.1

# 3. install nginx online
RUN yum -y install wget openssl \
	&& wget http://nginx.org/packages/centos/7/x86_64/RPMS/nginx-1.16.0-1.el7.ngx.x86_64.rpm \
	&& rpm -iv nginx-1.16.0-1.el7.ngx.x86_64.rpm \
	&& rm -f nginx-1.16.0-1.el7.ngx.x86_64.rpm

# 4. install mongodb online 
RUN wget https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.6/x86_64/RPMS/mongodb-org-3.6.4-1.el7.x86_64.rpm \
	&& wget https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.6/x86_64/RPMS/mongodb-org-server-3.6.4-1.el7.x86_64.rpm \
	&& wget https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.6/x86_64/RPMS/mongodb-org-shell-3.6.4-1.el7.x86_64.rpm \
	&& wget https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.6/x86_64/RPMS/mongodb-org-tools-3.6.4-1.el7.x86_64.rpm \
	&& wget https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.6/x86_64/RPMS/mongodb-org-mongos-3.6.4-1.el7.x86_64.rpm \
	&& rpm -iv mongodb-org-mongos-3.6.4-1.el7.x86_64.rpm \
	&& rpm -iv mongodb-org-shell-3.6.4-1.el7.x86_64.rpm \
	&& rpm -iv mongodb-org-tools-3.6.4-1.el7.x86_64.rpm \
	&& rpm -iv mongodb-org-server-3.6.4-1.el7.x86_64.rpm \
	&& rpm -iv mongodb-org-3.6.4-1.el7.x86_64.rpm \
        && rm -f mongodb-org-mongos-3.6.4-1.el7.x86_64.rpm \ 
		 mongodb-org-shell-3.6.4-1.el7.x86_64.rpm \ 
		 mongodb-org-tools-3.6.4-1.el7.x86_64.rpm \
		 mongodb-org-server-3.6.4-1.el7.x86_64.rpm \
		 mongodb-org-3.6.4-1.el7.x86_64.rpm

# 5. install common instructions online
RUN yum -y install openssh-clients net-tools telnet iproute which jq rsync htop atop iotop mtr 

# 6. install nginx config
RUN mkdir -p /opt/yi
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/website /usr/share/nginx/html

# 7. install mongodb config
RUN mkdir -p /var/lib/mongo

# 8. set timezone to Shanghai
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/shanghai" > /etc/timezone;

# 9. install supervisor4.0.2
RUN yum install -y python-setuptools hostname inotify-tools yum-utils && easy_install pip; pip install supervisor==4.0.2

# 10. create devops user
RUN yum install -y sudo
RUN echo "root:123qwe!@#" | chpasswd
#RUN useradd -rm -d /home/devops -s /bin/bash devops && echo 'devops'|passwd devops --stdin
#RUN echo "devops ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && chmod 0440 /etc/sudoers.d/user
#USER devops
#WORKDIR /home/devops

EXPOSE 80 27017 9001
#CMD ["nginx", "-g", "daemon off;"]
