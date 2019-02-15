FROM centos:7

RUN yum install -y autoconf libtool openssl-devel pcre-devel expat-devel make && yum clean all
COPY files/* /srv/

RUN cd /srv/ && tar xzf httpd-2.4.38.tar.gz && tar xzf apr-1.6.5.tar.gz && tar xzf apr-util-1.6.1.tar.gz 
RUN cd /srv/ && cp -R apr-1.6.5 httpd-2.4.38/srclib/apr && cp -R apr-util-1.6.1 httpd-2.4.38/srclib/apr-util
RUN cd /srv/httpd-2.4.38 && ./buildconf 
RUN cd /srv/httpd-2.4.38 && ./configure --enable-ssl  --enable-so --with-mpm=event --with-included-apr --with-apr=/usr/local/apr/bin 
RUN cd /srv/httpd-2.4.38 && make && make install
RUN useradd apache
RUN echo 'pathmunge /usr/local/apache2/bin' > /etc/profile.d/httpd.sh

EXPOSE 80

CMD /usr/local/apache2/bin/apachectl -D FOREGROUND
