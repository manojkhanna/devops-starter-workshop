FROM ubuntu:16.04

# Install curl for downloading, Java for running Logstash/JRuby, and netbase
# to resolve a warning from JRuby (https://github.com/jruby/jruby/issues/3955).
RUN apt-get update && \
    apt-get install -y curl netbase openjdk-8-jdk-headless && \
    apt-get clean

# Provide a non-root user to run the process.
RUN addgroup --gid 1000 logstash && \
    adduser --disabled-password --gecos=logstash --uid=1000 --gid=1000 \
            --home /usr/share/logstash --no-create-home logstash

# Add Logstash itself.
RUN curl -Lso - https://artifacts.elastic.co/downloads/logstash/logstash-5.2.2.tar.gz | \
    tar zxf - -C /usr/share && \
    mv /usr/share/logstash-5.2.2 /usr/share/logstash && \
    chown --recursive logstash:logstash /usr/share/logstash/ && \
    ln -s /usr/share/logstash /opt/logstash
ENV PATH=/usr/share/logstash/bin:$PATH

# Provide a minimal configuration, so that simple invocations will provide
# a good experience.
ADD config/log4j2.properties /usr/share/logstash/config/
ADD pipeline/petclinic-tomcat.conf /usr/share/logstash/pipeline/logstash.conf
RUN chown --recursive logstash:logstash /usr/share/logstash/config/ /usr/share/logstash/pipeline/

# Ensure Logstash has a UTF-8 locale available.
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LC_ALL='en_US.UTF-8'

USER logstash

CMD ["logstash", "-f", "/usr/share/logstash/pipeline/"]
