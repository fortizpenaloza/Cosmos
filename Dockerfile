FROM basmalltalk/pharo:6.1

WORKDIR /opt/pharo

ADD Cosmos.image Cosmos.image

CMD ["./pharo", "Cosmos.image", "cosmos", "--port=8090"]
