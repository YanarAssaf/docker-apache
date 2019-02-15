FROM centos:7

RUN yum install -y autoconf libtool openssl-devel pcre-devel expat-devel make && yum clean all
WORKDIR /srv
COPY files/* ./

RUN tar xzf httpd-2.4.38.tar.gz && tar xzf apr-1.6.5.tar.gz && tar xzf apr-util-1.6.1.tar.gz 
RUN cp -R apr-1.6.5 httpd-2.4.38/srclib/apr && cp -R apr-util-1.6.1 httpd-2.4.38/srclib/apr-util
RUN cd /srv/httpd-2.4.38 && ./configure --enable-ssl  --enable-so --enable-mpms-shared=all --with-included-apr --with-apr=/usr/local/apr/bin 
RUN cd /srv/httpd-2.4.38 && make && make install
RUN useradd apache
RUN echo 'pathmunge /usr/local/apache2/bin' > /etc/profile.d/httpd.sh
RUN ln -sf /dev/stdout /usr/local/apache2/logs/access_log
RUN ln -sf /dev/stderr /usr/local/apache2/logs/error_log

EXPOSE 80

CMD /usr/local/apache2/bin/apachectl -D FOREGROUND
