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

Once the base image is in Docker, it can be exported with

     docker save rhel68 > docker-rhel68.tar
     gzip docker-rhel68.tar

#### Preparation
RTC requires that the system allows many files to be open at the same time.
Since Docker can only use settings that are smaller than those of the host, the settings for these
must be updated on the host.

Edit the `/etc/security/limits.conf` file and add the following lines:

    * hard nofile 65536
    * soft nofile 65536
    * hard nproc 10000
    * soft nproc 10000
    
**Important**: The host must be restarted for these settings to take into effect.

#### Docker installation
To install Docker do 

    yum localinstall --nogpgcheck docker-engine-1.7.1-1.el6.x86_64.rpm
    
Docker download link: [https://yum.dockerproject.org/repo/main/centos/6/Packages/docker-engine-1.7.1-1.el6.x86_64.rpm](https://yum.dockerproject.org/repo/main/centos/6/Packages/docker-engine-1.7.1-1.el6.x86_64.rpm)

Due to fact that RTC images are so big and to prevent networking issues, ensure that the file `/etc/sysconfig/docker` contains
    
     other_args="--iptables=false --bip=10.0.0.10/24 --storage-driver=devicemapper --storage-opt dm.basesize=20G"
After which, you must do

     service docker start

#### RHEL Docker base image import
To import the Docker base image do

     gunzip docker-rhel68.tar.gz
     docker load < docker-rhel68.tar
     docker images   
     
The image 'rhel68' should now be listed. 

#### Prior to build
The following steps need to be performed prior to building the image in order to customize the installation.

##### Indentify and capture the parameters to use
The various builds have `repotools-params` files that contain parameters can are specific to the installation.
Things like IP addresses and account credentials.  These files must be reviewed to ensure they are accurate.
`ToDo`: A full description of each field will be provided in the future.

##### LDAP groups created
The JTS build is configured to setup LDAP and requires some groups to exist, mainly:

* Jazz_Admins
* Jazz_Project_Admins
* Jazz_Users
* Jazz_Guests

*Note:* These differ from the default groups for legacy reasons (i.e. these have extra underscores).
Currently, these setup scripts are hardcoded to these groups but providing the ability to specify particular groups will probably be added at a later date.

##### Hosts file update
The Docker containers aren't yet set up with a specific DNS server entry so most parameters are currently specified as IPs.
That will change in the near future.  For now, the URL of the JTS server, for example, must be set in the `/etc/hosts` file of the host pointing to `localhost` to ensure the application inside the container can find itself.
The same applies when pointing to other remote applications like CCM. 

#### To Build

The build is made up of various parts.

jtscore - First, we build a base image that contains all the installers needed for RTC
jts - Using the `jtscore` image, we run the setup for JTS and a few bundled apps. The setup includes licensing, LDAP and SMTP settings.
ccm - Using the `jtscore` image and relying on an already running JTS server, we setup individuals apps (like 'ccm').

At the end, we are left with images for 'jts' and for each of the individual apps.  The 'jtscore' image can be destroyed once all other images have been created.

'install' scripts are available that perform the various stages automatically. 
I.e.

* Builds the base image using `docker build`
* Runs the 'repotools' setup script from within a running container off that base image.
* Does a `docker commit` to create a new image based on that container instance now configured post setup.
* Deletes the original image and the the temporary container
* Runs a container using the new committed image.

##### JTS Core build

Requires the following files to be present at time of build.

* jts/CLM-Web-Installer-Linux-6.0.2.zip      - Installer for IBM CLM tools - ([Download](https://jazz.net/downloads/clm/releases/6.0.2/CLM-Web-Installer-Linux-6.0.2.zip))
* jts/JTS-CCM-QM-RM-JRS-RELM-repo-6.0.2.zip  - Repository containing CLM tools - ([Download](https://jazz.net/downloads/clm/releases/6.0.2/JTS-CCM-QM-RM-JRS-RELM-repo-6.0.2.zip))
* jts/sqljdbc_4.0.2206.100_enu.tar.gz        - JDBC Driver for SQL Server - ([Download](https://www.microsoft.com/en-ca/download/details.aspx?id=11774))


Within the 'jtscore' folder type:

    docker build --rm -t jtscore .

This builds the 'base' image from which we can do a specific instance build.
I.e. We are now ready to create a new image that will be specific to an installation URL.

#### JTS build

In this step, a container is run using the 'jtscore' image built earlier.  Within this container, 
the `repotools-jts.sh -setup` script is invoked to setup the various applications.
This includes setting up:

* the access URL
* the database access strings and password
* creating the database tables
* the LDAP settings
* the SMTP settings
* the licensing parameters (ToDo)

After the setup has been run, the container will be stopped and a new 'final' image 
will be created using that container.

Prior to running the final build, **empty databases must be created** matching the parameters
found in the `jts.response` file.
This can be done using the `create-databases.sql` script using the Management Studio connected to your database server.
Ensure the password match the ones in the `repotools-params` file.

The following files must be present:

* silent-install-server2.xml             `Answer file for installation`
* repotools-param      `Answer file parameters with specific values to use`

To perform the final build from the `jts` folder, run 
    
    ./jts-install.sh

This will result in a new `jts-final` image be created and a container named `myfinalccm` to run using that image.

#### To access

**Note:** On first launch, the JTS application (and others) can take a few minutes to come up.
Wait a certain amount of time prior to access the applications.

Point browser to the address that was specified in the `repotools-params` file.
Example: https://mydomain:9443/jts`

At this point, you will have a portion of the CLM applications up and running.
To log in use your LDAP credentials for a user that is part of the `Jazz_Admins` group.

This is the current state. This README will be updated to reflect the current state.

## Roadmap

The plan is to have the Docker image act as a template from which different CLM application sets can be 
instantiated.

I.e. the first time the container is run, it will finish the installation of the selected application
 and register it to the specified JTS server.  On subsequent runs after, it will simply run the application(s)
 within the image.

Left to be done includes:

* Licensing
* Certificates for HTTPS and secure LDAP.
* NTP configuration

At this time, the Docker image creation and running does not create the databases in MS SQL Server.
Those, at this time, must be created by running the `create-databases.sql` script using the Management Studio.

## Known issues

### Applications coming up as 'type' of 'unknown' in the registered applications list.
Not sure why this can happen, but usually restarting the JTS server using `docker restart jts-app` will resolve the issue.
