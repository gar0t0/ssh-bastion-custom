#!/bin/bash
## Script used for build image
## Tiago Machado <gar0t0@gmail.com> - 13/03/2021
## 

## Global Variables
TMPDIR="/tmp/utils"

## Variables oc
OC_PACKAGE="https://mirror.openshift.com/pub/openshift-v3/clients/3.11.400-1/linux/oc.tar.gz"
OC_PACKAGE_NAME="$(echo $OC_PACKAGE | awk -F '/' '{ sub(".tar.gz",""); print $9 }')"

## Variables kubectl
KUBECTL_PACKAGE="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
KUBECTL_PACKAGE_NAME="$(echo $KUBECTL_PACKAGE | awk -F '/' '{ print $9}')"
KUBECTL_PACKAGE_CHECKSUM="https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
KUBECTL_PACKAGE_CHECKSUM_NAME="$(echo $KUBECTL_PACKAGE_CHECKSUM | awk -F '/' '{ print $8}')"

## Variables kubectx
KUBECTX_PACKAGE="https://github.com/ahmetb/kubectx/releases/download/v0.9.3/kubectx_v0.9.3_linux_x86_64.tar.gz"
KUBECTX_PACKAGE_NAME="$(echo $KUBECTX_PACKAGE | awk -F '/' '{ sub(".tar.gz",""); print $9}')"
KUBECTX_PACKAGE_CHECKSUM="https://github.com/ahmetb/kubectx/releases/download/v0.9.3/checksums.txt"
KUBECTX_PACKAGE_CHECKSUM_NAME="$(echo $KUBECTX_PACKAGE_CHECKSUM | awk -F '/' '{ print $9 }')"

## Variables kubens
KUBENS_PACKAGE="https://github.com/ahmetb/kubectx/releases/download/v0.9.3/kubens_v0.9.3_linux_x86_64.tar.gz"
KUBENS_PACKAGE_NAME="$(echo $KUBENS_PACKAGE | awk -F '/' '{ sub(".tar.gz",""); print $9}')"
KUBENS_PACKAGE_CHECKSUM="https://github.com/ahmetb/kubectx/releases/download/v0.9.3/checksums.txt"
KUBENS_PACKAGE_CHECKSUM_NAME="$(echo $KUBECTX_PACKAGE_CHECKSUM | awk -F '/' '{ print $9 }')"

## Remove old directory if exist
if [ -d $TMPDIR ]
then
	rm -rf $TMPDIR 
fi

## Create Directory
mkdir -p $TMPDIR

## Download OpenShift oc and verify md5
printf "\033[0;32mDownload oc binary\n"
curl -L $OC_PACKAGE --output $TMPDIR/$OC_PACKAGE_NAME.tar.gz

## Install oc
tar -xf $TMPDIR/$OC_PACKAGE_NAME.tar.gz -C $TMPDIR
install -o root -g root -m 0755 $TMPDIR/oc /usr/local/bin/oc
printf "\033[0;32moc Install completed\n"


######################
## Download kubectl ##kubectl.sha256
######################
printf "\033[0;32mDownload kubectl binary\n"
curl -L $KUBECTL_PACKAGE --output $TMPDIR/$KUBECTL_PACKAGE_NAME
curl -L $KUBECTL_PACKAGE_CHECKSUM --output $TMPDIR/$KUBECTL_PACKAGE_CHECKSUM_NAME

#####################
## Install kubectl ##
#####################
KUBECTL_CHECKSUM="$(sha256sum $TMPDIR/$KUBECTL_PACKAGE_NAME | awk '{ print $1}')"
KUBECTL_VERIFY="$(grep $KUBECTL_CHECKSUM $TMPDIR/$KUBECTL_PACKAGE_CHECKSUM_NAME)"
if [ $? -eq 0 ]
then
   printf "\033[0;32mChecksum is valid\nkubectl install initialize\n"
   install -o root -g root -m 0755 $TMPDIR/$KUBECTL_PACKAGE_NAME /usr/local/bin/kubectl
   printf "\033[0;32mkubectl Install completed\n"
else
   printf  '\033[0;31mInvalid SHA256 hash, verify file\n'
   exit 0
fi

## Download kubectx
printf "\033[0;32mDownload kubectx binary\n"
curl -L $KUBECTX_PACKAGE --output $TMPDIR/$KUBECTX_PACKAGE_NAME.tar.gz
curl -L $KUBECTX_PACKAGE_CHECKSUM --output $TMPDIR/$KUBECTX_PACKAGE_CHECKSUM_NAME

#####################
## Install kubectx ##
#####################
KUBECTX_CHECKSUM="$(sha256sum $TMPDIR/$KUBECTX_PACKAGE_NAME.tar.gz | awk '{ print $1}')"
KUBECTX_VERIFY="$(grep $KUBECTX_CHECKSUM $TMPDIR/$KUBECTX_PACKAGE_CHECKSUM_NAME)"
if [ $? -eq 0 ]
then
   printf "\033[0;32mChecksum is valid\nkubectx install initialize\n"
   tar -xf $TMPDIR/$KUBECTX_PACKAGE_NAME.tar.gz -C $TMPDIR
   install -o root -g root -m 0755 $TMPDIR/kubectx /usr/local/bin/kubectx
   printf "\033[0;32mkubectx Install completed\n"
else
   printf  '\033[0;31mInvalid SHA256 hash, verify file\n'
   exit 0
fi


## Download kubens
#curl  --output $TMPDIR/kubens.tar.gz

## Download kubectx
printf "\033[0;32mDownload kubens binary\n"
curl -L $KUBENS_PACKAGE --output $TMPDIR/$KUBENS_PACKAGE_NAME.tar.gz
curl -L $KUBENS_PACKAGE_CHECKSUM --output $TMPDIR/$KUBENS_PACKAGE_CHECKSUM_NAME

#####################
## Install kubens ##
#####################
KUBENS_CHECKSUM="$(sha256sum $TMPDIR/$KUBENS_PACKAGE_NAME.tar.gz | awk '{ print $1}')"
KUBENS_VERIFY="$(grep $KUBENS_CHECKSUM $TMPDIR/$KUBENS_PACKAGE_CHECKSUM_NAME)"
if [ $? -eq 0 ]
then
   printf "\033[0;32mChecksum is valid\nkubens install initialize\n"
   tar -xf $TMPDIR/$KUBENS_PACKAGE_NAME.tar.gz -C $TMPDIR
   install -o root -g root -m 0755 $TMPDIR/kubens /usr/local/bin/kubens
   printf "\033[0;32mkubens Install completed\n"
else
   printf  '\033[0;31mInvalid SHA256 hash, verify file\n'
   exit 0
fi

## Remove $TMPDIR
rm -rf $TMPDIR