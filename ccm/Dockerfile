FROM jtscore

MAINTAINER Michel Vallee

WORKDIR /tmp/clm-installer/im/linux.gtk.x86_64/

COPY silent-install-server2.xml /tmp/clm-installer/im/linux.gtk.x86_64/

RUN ./installc -acceptLicense -showVerboseProgress -input silent-install-server2.xml --launcher.ini silent-install.ini

WORKDIR /opt/IBM/JazzTeamServer/server/

RUN mkdir /opt/IBM/JazzTeamServer/server/liberty/wlp/etc \
    && echo -Xms8192m > /opt/IBM/JazzTeamServer/server/liberty/wlp/etc/jvm.options \
    && echo -Xmx8192m > /opt/IBM/JazzTeamServer/server/liberty/wlp/etc/jvm.options \
    && mkdir /opt/IBM/JazzTeamServer/server/sqlserver \
    && cp /opt/sqljdbc/sqljdbc4.jar /opt/IBM/JazzTeamServer/server/sqlserver/

EXPOSE 9443

COPY jts.response.tmpl /opt/IBM/JazzTeamServer/server/
COPY repotools-install.sh /opt/IBM/JazzTeamServer/server/
RUN chmod 755 /opt/IBM/JazzTeamServer/server/repotools-install.sh

CMD ["/opt/IBM/JazzTeamServer/server/server.startup","-run"]
    
