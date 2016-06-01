FROM rhel68

MAINTAINER Michel Vallee

#RUN yum -y update \
#    && yum -y install tar unzip \
#    && yum clean all

RUN echo "* hard nofile 65536" >> /etc/security/limits.conf \
    && echo "* soft nofile 65536" >> /etc/security/limits.conf \
    && echo "* hard nproc 10000" >> /etc/security/limits.conf \
    && echo "* soft nproc 10000" >> /etc/security/limits.conf 

COPY CLM-Web-Installer-Linux-6.0.2.zip /tmp/clm-installer/
WORKDIR /tmp/clm-installer/
RUN unzip /tmp/clm-installer/CLM-Web-Installer-Linux-6.0.2.zip \
    && rm -rf /tmp/clm-installer/*.zip


COPY JTS-CCM-QM-RM-JRS-RELM-repo-6.0.2.zip /tmp/im-repo/
WORKDIR /tmp/im-repo/
RUN unzip /tmp/im-repo/JTS-CCM-QM-RM-JRS-RELM-repo-6.0.2.zip \
    && rm -rf /tmp/im-repo/*.zip


WORKDIR /tmp/sqljdbc/   
COPY sqljdbc_4.0.2206.100_enu.tar.gz /tmp/sqljdbc/
RUN tar -gunzip -xvf /tmp/sqljdbc/sqljdbc_4.0.2206.100_enu.tar.gz \
    && mkdir /opt/sqljdbc/  \
    && cp /tmp/sqljdbc/sqljdbc_4.0/enu/sqljdbc4.jar /opt/sqljdbc/ \
    && rm -rf /tmp/sqljdbc/ \
    && echo "export SQLSERVER_JDBC_DRIVER_FILE=/opt/sqljdbc/sqljdbc4.jar" >> ~root/.bashrc
    
CMD ["/bin/bash"]
