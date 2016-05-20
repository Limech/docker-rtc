FROM centos:6.7

MAINTAINER Michel Vallee

RUN yum -y update \
    && yum -y install tar unzip \
    && yum clean all

RUN echo "* hard nofile 65536" >> /etc/security/limits.conf \
    && echo "* soft nofile 65536" >> /etc/security/limits.conf \
    && echo "* hard nproc 10000" >> /etc/security/limits.conf \
    && echo "* soft nproc 10000" >> /etc/security/limits.conf 

COPY CLM-Web-Installer-Linux-6.0.2.zip /tmp/clm-installer/
WORKDIR /tmp/clm-installer/
RUN unzip /tmp/clm-installer/CLM-Web-Installer-Linux-6.0.2.zip

COPY JTS-CCM-QM-RM-JRS-RELM-repo-6.0.2.zip /tmp/im-repo/
WORKDIR /tmp/im-repo/
RUN unzip /tmp/im-repo/JTS-CCM-QM-RM-JRS-RELM-repo-6.0.2.zip

COPY silent-install-server2.xml /tmp/clm-installer/im/linux.gtk.x86_64/

WORKDIR /tmp/sqljdbc/   
COPY sqljdbc_4.0.2206.100_enu.tar.gz /tmp/sqljdbc/
RUN tar -gunzip -xvf /tmp/sqljdbc/sqljdbc_4.0.2206.100_enu.tar.gz \
    && mkdir /opt/sqljdbc/  \
    && cp /tmp/sqljdbc/sqljdbc_4.0/enu/sqljdbc4.jar /opt/sqljdbc/ \
    && rm -rf /tmp/sqljdbc/ \
    && echo "export SQLSERVER_JDBC_DRIVER_FILE=/opt/sqljdbc/sqljdbc4.jar" >> ~root/.bashrc
    

WORKDIR /tmp/clm-installer/im/linux.gtk.x86_64/

RUN ./installc -acceptLicense -showVerboseProgress -input silent-install-server2.xml --launcher.ini silent-install.ini

RUN rm -rf /tmp/clm-installer/ \
    && rm -rf /tmp/im-repo/ \
    && rm -rf /tmp/silent-install/

## For debugging.. eventually remove from image.
RUN yum -y install iputils

## Create database remotely using sqlcmd (on hold)
#COPY msodbcsql-11.0.2270.0.tar.gz /tmp/msodbcsql/
#COPY unixODBC-2.3.0.tar.gz /tmp/msodbcsql/
#WORKDIR /tmp/msodbcsql/  
#RUN tar -gunzip -xvf /tmp/msodbcsql/msodbcsql-11.0.2270.0.tar.gz \
# && mkdir /opt/msodbcsql/ 
# && bash -f /tmp/msodbcsql/msodbcsql-11.0.2270.0/build_dm.sh --accept-license --download-url=file://tmp/msodbcsql/unixODBC-2.3.0.tar.gz
# && rm -rf /tmp/msodbcsql/ 
#COPY create-database.sql /opt/msodbcsql/
 
   
CMD ["/bin/bash"]
# For now, assume container is being used for debugging 'repotools' setup scripting so don't launch server yet.
#CMD ["/opt/IBM/JazzTeamServer/server/server.startup","-run"]

    