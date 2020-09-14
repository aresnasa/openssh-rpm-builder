FROM centos:7.2.1511
WORKDIR /root/rpmbuild/SPECS/
RUN rpm -qa|wc -l
RUN yum install wget epel-release -y
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
RUN wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
RUN sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
RUN mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
RUN mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
RUN wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
RUN mkdir -p /root/rpmbuild/{SOURCES,SPECS}
RUN yum install vim rpm-build gcc make glibc-devel libXt-devel gtk2-devel -y
RUN yum install openssl openssl-devel krb5-devel pam-devel libX11-devel xmkmf libXt-devel gtk2-devel -y
RUN yum install rpm-build -y
RUN wget http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.3p1.tar.gz
RUN wget https://src.fedoraproject.org/lookaside/pkgs/openssh/x11-ssh-askpass-1.2.4.1.tar.gz/8f2e41f3f7eaa8543a2440454637f3c3/x11-ssh-askpass-1.2.4.1.tar.gz
RUN tar -zxf openssh-8.3p1.tar.gz
RUN cp ./openssh-8.3p1/contrib/redhat/openssh.spec /root/rpmbuild/SPECS/
RUN cp openssh-8.3p1.tar.gz /root/rpmbuild/SOURCES/
RUN cp x11-ssh-askpass-1.2.4.1.tar.gz /root/rpmbuild/SOURCES/
RUN cd /root/rpmbuild/SPECS/;ls
RUN sed -i "s/%global no_gnome_askpass 0/%global no_gnome_askpass 1/g" openssh.spec
RUN sed -i "s/%global no_x11_askpass 0/%global no_x11_askpass 1/g" openssh.spec
RUN sed -i "s/BuildRequires: openssl-devel >= 1.0.1/#BuildRequires: openssl-devel >= 1.0.1/g" openssh.spec
RUN sed -i "s/BuildRequires: openssl-devel < 1.1/#BuildRequires: openssl-devel < 1.1/g" openssh.spec
RUN sed -i 's/^%__check_fil/#&/' /usr/lib/rpm/macros
RUN cat openssh.spec|grep ask
# Install devel
RUN yum install gcc make -y
RUN rpmbuild -bb openssh.spec
RUN sed -i 's/^#%__check_files/%__check_files/g' /usr/lib/rpm/macros
RUN yum install yum-utils applydeltarpm -y
WORKDIR /root/rpmbuild/RPMS/x86_64
#RUN echo $(ls|grep server|xargs|awk -F '\-' {'print $'}) > package.txt
#RUN cat package.txt
#RUN yumdownloader glibc libedit libgcc libICE libSM libstdc++ libthai libXau libxcb libXrender libXt nspr pango fipscheck fipscheck-lib libedit glibc-common libICE libX11 libX11-common libXt libgcc libstdc++ libxcb ncurses-libs ncurses-base nss-softokn-freebl nss-util nspr nss-util
#RUN yum install --downloadonly --downloaddir=/root/rpmbuild/RPMS/x86_64 atk avahi-libs cairo cups-libs dejavu-fonts-common dejavu-sans-fonts fontconfig fontpackages-filesystem fribidi gdk-pixbuf2 graphite2 gtk-update-icon-cache gtk2 harfbuzz hicolor-icon-theme jasper-libs jbigkit-libs libXcomposite libXcursor libXdamage libXext libXfixes libXft libXi libXinerama libXrandr libXrender libXxf86vm libglvnd libglvnd-egl libglvnd-glx libjpeg-turbo libpng libsmartcols libthai libtiff libuuid libwayland-client libwayland-server libxshmfence mesa-libEGL mesa-libGL mesa-libgbm mesa-libglapi pango pixman dbus dbus-libs freetype glib2 libblkid libdrm libmount ncurses util-linux
RUN rpm -qa|wc -l
RUN yumdownloader atk avahi-libs cairo cups-libs dejavu-fonts-common dejavu-sans-fonts fontconfig fontpackages-filesystem fribidi gdk-pixbuf2 graphite2 gtk-update-icon-cache gtk2 harfbuzz hicolor-icon-theme jasper-libs jbigkit-libs libXcomposite libXcursor libXdamage libXext libXfixes libXft libXi libXinerama libXrandr libXrender libXxf86vm libglvnd libglvnd-egl libglvnd-glx libjpeg-turbo libpng libsmartcols libthai libtiff libuuid libwayland-client libwayland-server libxshmfence mesa-libEGL mesa-libGL mesa-libgbm mesa-libglapi pango pixman dbus dbus-libs freetype glib2 libblkid libdrm libmount ncurses util-linux
#RUN yumdownloader --resolve openssh-server openssh-client openssh openssh-debuginfo
RUN rm -f *.i686.rpm
RUN ls

