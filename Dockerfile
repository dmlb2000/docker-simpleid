# Copyright (C) 2015, BMW Car IT GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

FROM fedora:21
MAINTAINER Michael Knapp <michael.knapp@bmw-carit.de>

# set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# install needed packages
RUN yum upgrade -y && \
	yum install -y \
		curl \
		https \
		mod_ssl \
		net-tools \
		openssl \
		php \
		php-bcmath \
		php-pdo \
		php-xml \
		tar \
		wget && \
	yum clean all

# configure php
RUN sed -i -e 's/;date.timezone.*/date.timezone = Europe\/Berlin/g' /etc/php.ini && \
	sed -i -e 's/display_errors.*/display_errors = On/g' /etc/php.ini

# configure apache server
COPY httpd.conf /etc/httpd/conf/httpd.conf

# install simpleid server
RUN mkdir -p /data
RUN cd /data && \
	wget http://downloads.sourceforge.net/simpleid/simpleid-0.9.1.tar.gz && \
	tar xzf simpleid-0.9.1.tar.gz && \
	rm simpleid-0.9.1.tar.gz
RUN cd /var/www/html/ && ln -s /data/simpleid/www simpleid

# configure simpleid server
COPY config.php /data/simpleid/www/config.php.dist
VOLUME /data/simpleid/identities
RUN chmod o+w /data/simpleid

# copy default identities
COPY identities/ /data/simpleid/identities

# add start script
COPY start.sh /data/start.sh

# expose https port
EXPOSE 443

ENTRYPOINT ["/data/start.sh"]
