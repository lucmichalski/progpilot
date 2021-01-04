FROM composer:latest

# add unpriviledged user and 
# create directory for the code to be scanned
RUN addgroup -S tool && adduser -S -G tool tool && \
     mkdir -p /opt/mount/

# WORKDIR /tmp

RUN curl -sL -o /usr/bin/phar-composer.phar https://github.com/clue/phar-composer/releases/download/v1.2.0/phar-composer-1.2.0.phar
RUN echo $(command -v phar-composer.phar) && chmod +x /usr/bin/phar-composer.phar

RUN git clone --depth=1 https://github.com/designsecurity/progpilot && \
	cd progpilot && \
	./build.sh && \
	ls -l builds && \
	mv ./builds/progpilot_dev*.phar /usr/local/bin/progpilot

COPY ./projects/example_config/configuration.yml /opt/configuration.yml

WORKDIR /opt/mount

# change user
USER tool

ENTRYPOINT [ "progpilot", "--configuration", "/opt/configuration.yml", "/opt/mount"]