FROM docker.elastic.co/logstash/logstash:5.2.2
RUN rm -f /usr/share/logstash/pipeline/logstash.conf
ADD pipeline/logstash.yml /usr/share/logstash/pipeline/
ADD settings/logstash.conf /usr/share/logstash/config/
