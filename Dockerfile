FROM oraclelinux

RUN yum install -y oracle-rdbms-server-12cR1-preinstall sudo unzip libXtst libXrender sudo bc net-tools libaio 

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/weblogic && \
    echo "weblogic:x:${uid}:${gid}:Weblogic,,,:/home/weblogic:/bin/bash" >> /etc/passwd && \
    echo "weblogic:x:${uid}:" >> /etc/group && \
    echo "weblogic ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/weblogic && \
    chmod 0440 /etc/sudoers.d/weblogic && \
    chown ${uid}:${gid} -R /home/weblogic

RUN echo "oracle ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/oracle && \
    chmod 0440 /etc/sudoers.d/oracle

RUN mkdir -p /u01/oracle/pogramas
RUN mkdir -p /u01/oracle/scrics
RUN chown -R oracle. /u01/oracle

RUN mkdir -p /u01/weblogic/pogramas
RUN mkdir -p /u01/weblogic/scrics
RUN chown -R oracle. /u01/oracle

USER oracle

#################
# Install BBDD #
#################
RUN cd /u01/oracle/pogramas && \
    curl -O http://172.17.0.1:8080/bbdd/fitxers/response_BBDD.rsp && \
    curl -O http://172.17.0.1:8080/bbdd/linuxamd64_12102_database_1of2.zip && \
    curl -O http://172.17.0.1:8080/bbdd/linuxamd64_12102_database_2of2.zip && \
    unzip linuxamd64_12102_database_1of2.zip && \
    unzip linuxamd64_12102_database_2of2.zip && \
    cd /u01/oracle/pogramas/database && \
    ./runInstaller -waitforcompletion -showProgress -logLevel finest -ignoreSysPrereqs -ignorePrereq -silent -responseFile /u01/oracle/pogramas/response_BBDD.rsp && \
    cd /u01 && rm /u01/oracle/pogramas/linuxamd64_12102_database_1of2.zip /u01/oracle/pogramas/linuxamd64_12102_database_2of2.zip && rm -rf /u01/oracle/pogramas/database && \
    /u01/oracle/app/oracle/product/12.1.0/dbhome_1/bin/dbca -silent -createDatabase -templateName General_Purpose.dbc -gdbname dev -sid dev -responseFile NO_VALUE -characterSet AL32UTF8 -memoryPercentage 20 -emConfiguration NONE -sysPassword oracle -systemPassword oracle

USER root
RUN chown -R weblogic. /u01/weblogic

USER weblogic

################
# Install JAVA #
################

ENV vd_java=jdk-8u152-linux-x64.tar.gz

#Install JAVA
RUN cd /u01/weblogic/pogramas && \
    curl -O http://172.17.0.1:8080/java/$vd_java && \
    tar -xzvf $vd_java && \
    mv `tar -tzf $vd_java | head -1` /u01/weblogic/java && \
    rm /u01/weblogic/pogramas/$vd_java

########################
#Install Infrastructure#
########################

RUN cd /u01/weblogic/pogramas && \
    curl -O http://172.17.0.1:8080/wls/fitxers/response_wls.rsp && \
    curl -O http://172.17.0.1:8080/wls/fitxers/inventory.loc

ENV vd_binwls=/u01/weblogic/mid12212
ENV vd_type='Fusion Middleware Infrastructure'



RUN vd_binwls_sed=`echo $vd_binwls|sed -e 's/\//\\\\\//g'` && \
    sed -i '/ORACLE_HOME/s/ORACLE_HOME=[^"]*/ORACLE_HOME='$vd_binwls_sed'/' /u01/weblogic/pogramas/response_wls.rsp 
RUN sed -i "/INSTALL_TYPE/s/INSTALL_TYPE=[^.]*/INSTALL_TYPE=$vd_type/" /u01/weblogic/pogramas/response_wls.rsp

RUN cat /u01/weblogic/pogramas/response_wls.rsp

ENV vd_orainventory=/u01/weblogic/oraInventory
ENV vd_inst_group=weblogic

RUN vd_orainventory_sed=`echo $vd_orainventory|sed -e 's/\//\\\\\//g'` && \
    sed -i "/inventory_loc/s/inventory_loc=[^.]*/inventory_loc=$vd_orainventory_sed/" /u01/weblogic/pogramas/inventory.loc
RUN sed -i "/inst_group/s/inst_group=[^.]*/inst_group=$vd_inst_group/" /u01/weblogic/pogramas/inventory.loc 

RUN cat /u01/weblogic/pogramas/inventory.loc /u01/weblogic/pogramas/response_wls.rsp

ENV vd_inf=fmw_12.2.1.2.0_infrastructure.jar

#Install Infrastructure
RUN cd /u01/weblogic/pogramas && \
    curl -O http://172.17.0.1:8080/wls/$vd_inf && \
    /u01/weblogic/java/bin/java -Djava.io.tmpdir=/u01/weblogic/tmp -Xmx1024m -jar /u01/weblogic/pogramas/$vd_inf -silent -responseFile /u01/weblogic/pogramas/response_wls.rsp -invPtrLoc /u01/weblogic/pogramas/inventory.loc && \
    sed -i -e 's/^JVM_ARGS="/JVM_ARGS="-Djava.security.egd=file:\/dev\/.\/urandom /' /u01/weblogic/$vd_binwls/oracle_common/common/bin/wlst.sh && \
    rm /u01/weblogic/pogramas/$vd_inf

ENV vd_soft=fmw_12.2.1.2.0_soa.jar
ENV vd_component="SOA Suite"
RUN sed -i -e 's/^ORACLE_HOME=/ORACLE_HOME=\/u01\/weblogic\/'"$vd_binwls"'/' /u01/weblogic/pogramas/response_soa.rsp
RUN sed -i -e 's/^INSTALL_TYPE=/INSTALL_TYPE='"$vd_component"'/' /u01/weblogic/pogramas/response_soa.rsp

#Install BPEL
RUN cd /u01/weblogic/pogramas && \
    curl -O http://172.17.0.1:8080/soa/$vd_soft && \
    /u01/weblogic/java/bin/java -Djava.io.tmpdir=/u01/weblogic/tmp -Xmx1024m -jar /u01/weblogic/pogramas/$vd_soft -silent -invPtrLoc /u01/weblogic/pogramas/inventory.loc -ignoreSysPrereqs -responseFile /u01/weblogic/pogramas/response_soa.rsp && \
    export vd_component="BPM" && \
    sed -i -e 's/^\(INSTALL_TYPE=.*\)/INSTALL_TYPE='"$vd_component"'/' /u01/weblogic/pogramas/response_soa.rsp && \
    /u01/weblogic/java/bin/java -Djava.io.tmpdir=/u01/weblogic/tmp -Xmx1024m -jar /u01/weblogic/pogramas/$vd_soft -silent -invPtrLoc /u01/weblogic/pogramas/inventory.loc -ignoreSysPrereqs -responseFile /u01/weblogic/pogramas/response_soa.rsp && \
    rm /u01/weblogic/pogramas/$vd_soft

USER oracle

ENV vd_prefixrcu=BPEL

RUN /u01/oracle/scrics/start.sh && \
    sudo su - weblogic -c "export JAVA_HOME=/u01/weblogic/java && \
    /u01/weblogic/$vd_binwls/oracle_common/bin/rcu -silent -createRepository -connectString 127.0.0.1:1521:DEV -dbUser sys -dbRole SYSDBA -schemaPrefix $vd_prefixrcu -component IAU -component MDS -component IAU_APPEND -component IAU_VIEWER -component OPSS -component STB -component WLS -component UCSUMS -component SOAINFRA -component ESS -f < /u01/weblogic/pogramas/passwordfile.txt"

USER root
COPY scrics/weblogic/* /u01/weblogic/scrics/
RUN chown weblogic. /u01/weblogic/scrics/*
RUN chmod +x /u01/weblogic/scrics/*sh

USER oracle
RUN /u01/oracle/scrics/start.sh && \
    sudo su - weblogic -c "/u01/weblogic/scrics/create_domain.sh"


#    sudo su - weblogic -c "/u01/weblogic/scrics/create_domain.sh && \
#    cd /u01/weblogic/scrics && \
#    ln -s start.sh start_nodemanager && \
#    ln -s start.sh start_AdminServer && \
#    ln -s start.sh start_soa_server1 && \
#    ln -s start.sh start_soa_server2"

CMD /u01/oracle/scrics/start.sh && \
#    sudo su - weblogic -c "/u01/weblogic/scrics/start_ALL.sh" && \
    bash
