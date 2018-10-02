FROM basmalltalk/pharo:6.1

USER root

WORKDIR /opt/cosmos

RUN apt-get update \
  && apt-get --assume-yes --no-install-recommends install curl unzip \
  && curl get.pharo.org/61 | bash \
  && chown -R pharo:pharo /opt/cosmos

USER pharo

RUN /opt/pharo/pharo Pharo.image eval "Iceberg remoteTypeSelector: #httpsUrl. Metacello new baseline: 'Cosmos'; repository: 'github://iot-uca/back-end:master/source'; load: ('Deployment'). SmalltalkImage current closeSourceFiles; openSourceFiles; snapshot: true andQuit: true." 

CMD ["/opt/pharo/pharo", "/opt/cosmos/Pharo.image", "cosmos", "--port=8090", "--allowed-origins=http://localhost:7080"]

