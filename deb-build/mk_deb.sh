#!/bin/sh

echo 'START PACKAGE BUILDING'

# remove old packages
rm gibbmers*.deb 2> /dev/null

# copy program files from devel-source
if [ ! -e debian/usr/bin ]; then
    mkdir -p debian/usr/bin
fi
cp ../bin/gibbmers debian/usr/bin/

if [ ! -e debian/etc ]; then
    mkdir -p debian/etc
fi
cp ../gibbmers.conf.yml debian/etc/

if [ ! -e debian/usr/share/perl5/School/Evaluation/Gibbmers ]; then
    mkdir -p debian/usr/share/perl5/School/Evaluation/Gibbmers
fi
cp ../lib/School/Evaluation/Gibbmers/Chart.pm debian/usr/share/perl5/School/Evaluation/Gibbmers/

if [ ! -e debian/usr/share/applications ]; then
    mkdir -p debian/usr/share/applications
fi
cp ../gibbmers.desktop debian/usr/share/applications/gibbmers.desktop

if [ ! -e debian/usr/share/icons ]; then
    mkdir -p debian/usr/share/icons
fi
cp ../gibbmers48x48.png debian/usr/share/icons/gibbmers48x48.png

# pack manpage
if [ ! -e debian/usr/share/man/man1 ]; then
    mkdir -p debian/usr/share/man/man1
fi
cp gibbmers.1 debian/usr/share/man/man1/
gzip --best debian/usr/share/man/man1/*.1

# pack changelog
if [ ! -e debian/usr/share/doc/gibbmers ]; then
    mkdir -p debian/usr/share/doc/gibbmers
fi
cp changelog        debian/usr/share/doc/gibbmers/
cp changelog.Debian debian/usr/share/doc/gibbmers/
gzip --best debian/usr/share/doc/gibbmers/changelog
gzip --best debian/usr/share/doc/gibbmers/changelog.Debian

cp copyright debian/usr/share/doc/gibbmers/copyright

# update md5sums file of dep-tree
echo -e "\tupdate md5sums file"
if [ ! -e debian/DEBIAN ]; then
    mkdir debian/DEBIAN
fi
if [ -e debian/DEBIAN/md5sums ]; then
    rm debian/DEBIAN/md5sums
fi
for i in $( find ./debian -path ./debian/DEBIAN -prune -o -type f -print)
do
    md5sum $i | sed -e "s/\.\/debian\///g" >> debian/DEBIAN/md5sums
done

# renew the size information
sed -i '/Installed-Size/ d' debian/DEBIAN/control # delete
echo "Installed-Size: $(du -s --exclude DEBIAN debian/ | cut -f1)" >> debian/DEBIAN/control

# set file and folder permissions
chmod -R 755 debian/
chmod 644 debian/usr/share/man/man1/gibbmers.1.gz
chmod 644 debian/usr/share/doc/gibbmers/changelog.gz
chmod 644 debian/usr/share/doc/gibbmers/changelog.Debian.gz 
chmod 644 debian/etc/gibbmers.conf.yml
chmod 644 debian/usr/share/doc/gibbmers/copyright
chmod 644 debian/DEBIAN/md5sums
chmod 644 debian/DEBIAN/control
chmod 644 debian/DEBIAN/conffiles
chmod 644 debian/usr/share/perl5/School/Evaluation/Gibbmers/Chart.pm
chmod 644 debian/usr/share/icons/gibbmers48x48.png
chmod 644 debian/usr/share/applications/gibbmers.desktop

# create deb package
echo -e "\tbuild package"
fakeroot dpkg-deb --build debian \
$( grep Package debian/DEBIAN/control | cut -d" " -f2 )_\
$( grep Version debian/DEBIAN/control | cut -d" " -f2 )_\
$( grep Architecture debian/DEBIAN/control | cut -d" " -f2 )\
.deb

# remove packed things,
# I don't need it in src
rm debian/usr/share/man/man1/gibbmers.1.gz
rm debian/usr/share/doc/gibbmers/changelog.gz
rm debian/usr/share/doc/gibbmers/changelog.Debian.gz
rm debian/usr/share/perl5/School/Evaluation/Gibbmers/Chart.pm
rm debian/usr/bin/gibbmers
rm debian/etc/gibbmers.conf.yml
rm debian/usr/share/doc/gibbmers/copyright
rm -rf debian/etc debian/usr
