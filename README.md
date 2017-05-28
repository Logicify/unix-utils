# Unix Utils
This repository contains collection of usefull scripts which might be helpfull when seting up cloud based infrastructure. Some of the scripts are platform specific (e.g. AWS) others are very generic. 

Please check index below for more information about available scripts and also check [Contribution](CONTRIBUTION.MD) section for some instructions on making a submition to this repository.

## License

All scripts in this repository is distributed under [MIT license](LICENSE). Please keep this in mind if you want to contribute and follow instructions for [Contribution Guide](CONTRIBUTION.MD).

## Index 

1. Docker tools
	1. Dive (connect to bash of the running container)
    2. Copy Image
1. AWS
	1. Mount EBS
    2. Set Instance Host Name
    
### Docker: Dive

This utility allows to connect to the bash terminal in interactive mode of the running container. It might be very usefull for running maitanance work in dockerized environment. E.g. you have own docker image running you web application and in order to apply database migrations you need to run the command from inside of the container. 

Another usecase is maitenance commands on your containerized database instances, when you need to run backup\restore script from from your container.

#### Usage

Connect to specific container:

```
dive <container name>
```

Connect to the container specified in `/etc/dive-into-docker.conf` file. This should be a taxt file containing container name in the first and the only line. It might be usefull if you run only one container on your vm and do not want to type container name each time. 

```
dive
```

#### Contributors
**Author**: Dmitry Berezovsky (d@logicify.com)


### Docker: Copy Image

This tool allows to copy docker image from one repository to another. It also supports automatic login to ECR (Elastic Container Registry from AWS). This might be useful for different deployment scenarios. The most common one is promoting compiled image between environments. Let's say you have CI, UAT and PRODUCTION environments and you have built an image which was deployed into CI. Then once it passed prelimitary test cycle you might want to move it to UAT and then to PROD, but in order to guaranty that images which passed quality assurance and the one got deployed to PROD are equal you shouldn't rebuild it but rather copy to PRODUCTION repository (if you use separate repos for security reasons).

#### Usage

```
docker-image-copy [-l,--local] [-e,--ecr] [-h] [-t,--tag TAG] <source> <target>
	
    -l, --local       Get source image from local repository. If not set it script will try to pull remote
    -e, --ecr         Do ECR login before pull and push operations. Doesn't work in local mode (-l)
    -t, --tag         Assign tag in the SOURCE repository
    
    Positional arguments
    source            Source image tag
    target            Target image tag

    NOTE: Image tag should be fully qualified tag. Examples:
      - logicify/django:1.0               -   means docker image from docker hub repository
      - my_image:latest                   -   docker image from local repository
      - http://myrepo.com/my_image:1.0    -   docker image from remote repository
    
```

#### Contributors
**Author**: Dmitry Berezovsky (d@logicify.com)


### AWS: Mount EBS

This tool siplifies process of managing your block storage devices. Mounting EBS volume might be a bit tricky since it requires some additional checks and preparation. You need to check if given device has file system, if not - create one. Then you need to mount it and set appropriate permissions on the target folder to ensure the software using it will be able to operate properly. Also you might whant to update `fstab` file to be user that device will be mounted automatically after reboot.

Basically this script does all this steps. It mounts volume, creates file system only if needed and udates FSTAB. For now only ext4 file system is supported. 

**IMPORTANT NOTE FOR DOCKER USERS**: If you need to use mounted volume from your docker container be sure to **restart docker service** after runing this script otherwise you have a good chance to connect your root device to your container instead of mounted EBS.

Also note that since this script updates fstab there is no need to run it on each boot. You just need to run it once for each VM as a part of provision process.

#### Usage

```
mount-ebs <device> <mount-point>"
```

Example illustrates how to mount block device `/dev/sdh` to `/srv`:

```
mount-ebs /dev/sdh /srv
```


#### Contributors
**Author**: Dmitry Berezovsky (d@logicify.com)

### Set AWS Host Name

By default AWS sets host name of the EC2 instances to private DNS name which is an IP address of the instance in private network. This might be a problem if you want to identify your VMs by host name. 

This script makes it easier to set host names especially for instances managed by Autoscaling groups when you want to have all instances of the same autoscaling group to have the same prefix in hostname.

#### Usage

```
aws-set-hostname <prefix> [-s]

	-s		Do not add EC2 instance ID to the host name
```

Naming EC2 instances of the same autosacling group according to the pattern `webworker-<instanceid>`:

```
aws-set-hostname webworker
```

Set host name to `bastion` for current VM:

```
aws-set-hostname bastion -s
```


#### Contributors
**Author**: Dmitry Berezovsky (d@logicify.com)