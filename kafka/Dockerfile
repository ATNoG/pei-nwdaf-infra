FROM confluentinc/cp-kafka:7.7.1
COPY topics.txt /topics.txt
COPY create-topics.sh /create-topics.sh
CMD ["/create-topics.sh"]
