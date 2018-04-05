# TABLA DE POSIBLES INSTALACIONES
**Version/softw** | **Ansible** | **Local** | **Files** | **Variables**
-- | -- | :--: | -- | --
**WLS 12.2.1.2.0** |  |SI|  fmw_12.1.3.0.0_infrastructure.zip, response_wls.rsp|  ORACLE_HOME=/u01/middlware, Fusion Middleware Infrastructure
**WLS 12.1.3.0.0** |  |SI| fmw_12.2.1.2.0_infrastructure.zip, response_wls.rsp| ORACLE_HOME=/u01/middlware, Fusion Middleware Infrastructure
**WLS11g(10.3.6.0.0)** |  |SI | wls1036_generic.zip, response.xml| BEAHOME= /u01/middlware && WLS_INSTALL_DIR= $BEAHOME/wls10.3.6
**OSB 12.2.1.2.0**|  | SI|fmw_12.2.1.2.0_osb.zip, response_osb.rsp| Service Bus
**OSB 12.1.3.0.0** |  | SI|fmw_12.1.3.0.0_osb.zip, response_osb.rsp| Service Bus
**OSB 11.1.1.7.0** |  |SI |Osb11g.zip,response_osb11.rsp| WL_HOME=/u01/mid11/wls10.3
**FORMS 12.2.1.2.0**|  |SI |Forms12.2.1.2.zip, response_wls.rsp  |Forms and Reports Deployment
**FORMS 11.1.2.2.0**|  |SI| Forms11g,zip, response_Forms11.rsp, inventory11.loc | MV_HOME=/u01/mid11
**SOA 12.2.1.2.0**|  | SI|fmw_12.2.1.2.0_soa.zip, response_soa.rsp| BPM, Soa Suite
**SOA 12.1.3.0.0** |  |SI |fmw_12.1.3.0.0_soa.zip, response_soa.rsp| BPM, Soa Suite
**SOA 11.1.1.7.0** |  | SI|Soa11g.zip response_soa11.rsp| WLS





----
# TABLA DE COMPATIBILIDADES
**Producto** | **Java** | **Weblogic** | **BBDD** | **SO(64 bits)**
-- | -- | -- | -- | -- 
**OSB 12.2.1.2.0**| JDK 1.8.0 + | 12.2.1.2.0  | 12.2.0.1.0, 12.1.0.2.0, 12.1.0.1.0, 11.2.0.4.0 | SLES 11,12 ; RHEL 6.7 ; OL6,7
**OSB 12.1.3.0.0** | JDK 1.7.0 + |12.1.3.0.0 | 12.1.0.2.0, 12.1.0.1.0 | SLES 11 ; RHEL 5,6,7 ; OL 5,6,7 
**OSB 11.1.1.7.0** | JDK 1.7.0 + |10.3.6.0 | 12.1.0.2.0, 12.1.0.1.0, 11.2.0.4.0, 11.2.0.3.0, 11.2.0.2.0, 11.2.0.1.0, 11.1.0.7.0, 10.2.0.5.0, 10.2.0.4.0 | SLES 10,11 ; RHEL 4,5,6, ; OL 4,5,6 ; Exalogic 2.0
**FORMS 12.2.1.2.0** | JDK 1.8.0 + |12.2.1.2.0|(12.2.0.1.0, 12.1.0.2.0, 12.1.0.1.0, 11.2.0.4.0|SLES 12,11 ; RHEL 6,7 ; OL 6,7
**FORMS 11.1.2.2.0** |  JDK 1.7.0+ | 10.3.6.0.0 | (12.2.0.1.0, 12.1.0.2.0, 12.1.0.1.0, 11.2.0.4.0, 11.2.0.3.0, 11.2.0.2.0, 11.2.0.1.0, 11.1.0.7.0, 10.2.0.5.0, 10.2.0.4.0 |SLES 10,11,12 ; RHEL 4,5,6,7 ; OL 4,5,6
**SOA 12.2.1.2.0** | JDK 1.8.0 +  | 12.2.1.2.0 | 12.2.0.1.0, 12.1.0.2.0, 12.1.0.1.0, 11.2.0.4.0 | SLES 11,12 ; RHEL 6,7 ; Ol 6,7 
**SOA 12.1.3.0.0** | JDK 1.7.0 +  | 12.1.3.0.0 | 12.2.0.1.0, 12.1.0.2.0, 12.1.0.1.0, 11.2.0.4.0, 11.2.0.3.0, 11.1.0.7.0 | SLES 11 ; RHEL 5,6,7 ; OL 5,6,7
**SOA 11.1.1.7.0** | JDK 1.7.0 + | 10.3.6.0.0, 10.3.5.0.0 | 12.1.0.2.0, 12.1.0.1.0, 11.2.0.4.0, 11.2.0.3.0, 11.2.0.2.0, 11.2.0.1.0, 11.1.0.7.0, 10.2.0.5.0, 10.2.0.4.0 | SLES 10,11 ; RHEL 4,5,6 ; OL 4,5,6 ; Exalogic 2.0
