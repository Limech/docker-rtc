## Description

Dockerfile to create a Docker image for the IBM Collaborative Lifecycle Management (CLM) suite of tools.
This deploys the CLM applications within a 
 [WebSphere Liberty application server](https://developer.ibm.com/wasdev/) using an
  [IBM Installation Manager](https://jazz.net/downloads/ibm-installation-manager/) repository.

Note that the IBM CLM suite of tools are subject to license agreements and it is the responsability of the user 
to ensure all licenses and fees have been paid.  Many of the links provided are only available through the IBM 
download portal and should be obtained in alignment with IBM trademarks and regulations regarding the usage of
 these tools.

### Requirements
This was tested using Docker 1.7.1 on CentOS 6.8 and RHEL 6.8.  The base image for the containers
 can be CentOS 6.8 and RHEL 6.8 as well. 

To build a RHEL base image for Docker, follow this procedure:
   [http://cloudgeekz.com/625/howto-create-a-docker-image-for-rhel.html](http://cloudgeekz.com/625/howto-create-a-docker-image-for-rhel.html)

#### Docker installation
To install Docker do 

    yum localinstall --nogpgcheck docker-engine-1.7.1-1.el6.x86_64.rpm
    
Docker download link: [https://yum.dockerproject.org/repo/main/centos/6/Packages/docker-engine-1.7.1-1.el6.x86_64.rpm](https://yum.dockerproject.org/repo/main/centos/6/Packages/docker-engine-1.7.1-1.el6.x86_64.rpm)

*Warning* - Docker modified the routing table, the firewall and adds a virtual bridge adapter.  These actions 
might cause problems within a corporate environment. Investigations are still under way to figure out how best 
to minimize those impacts.

#### Prior to build
The following steps need to be performed prior to building the image in order to customize the installation.

#### To Build

Requires the following files to be present at time of build.

* jts/CLM-Web-Installer-Linux-6.0.2.zip      - Installer for IBM CLM tools - ([Download](https://jazz.net/downloads/clm/releases/6.0.2/CLM-Web-Installer-Linux-6.0.2.zip))
* jts/JTS-CCM-QM-RM-JRS-RELM-repo-6.0.2.zip  - Repository containing CLM tools - ([Download](https://jazz.net/downloads/clm/releases/6.0.2/JTS-CCM-QM-RM-JRS-RELM-repo-6.0.2.zip))
* jts/sqljdbc_4.0.2206.100_enu.tar.gz        - JDBC Driver for SQL Server - ([Download](https://www.microsoft.com/en-ca/download/details.aspx?id=11774))
* jts/silent-install-server2.xml             `Answer file for installation`

Within the 'jts' folder type:

    `docker build --rm -t jts .`

#### To Run
    `docker run -p 9443:9443 -d --name myjts jts`

#### To access
Point browser to `https://localhost:9443/jts`

At this point, you will have a portion of the CLM applications up and running, however, they will NOT be configured.
This is the current state. This README will be updated to reflect the current state.

## Roadmap

The plan is to have the Docker image act as a template from which different CLM application sets can be 
instantiated.

I.e. the first time the container is run, it will finish the installation of the selected application
 and register it to the specified JTS server.  On subsequent runs after, it will simply run the application(s)
 within the image.

Left to be done includes:

* Setup using `repotools-jts.sh` - which includes:
    * Application link up to JTS
    * Database configuration (including Data Warehouse)
    * LDAP configuration
    * SMTP configuration
* Certificates for HTTPS and secure LDAP.
* NTP configuration
* LDAP configuration within WebSphere Liberty

At this time, the Docker image creation and running does not create the databases in MS SQL Server.
Those, at this time, must be created by running the `create-databases.bat` script on the SQL Server host.


