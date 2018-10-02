FROM basmalltalk/pharo:6.1

WORKDIR /opt/pharo

RUN apt-get update \
  && apt-get --assume-yes --no-install-recommends install curl unzip \
  && curl get.pharo.org/61 | bash \
  && ./pharo Pharo.image eval "Metacello new baseline: 'Cosmos'; repository: 'github://iot-uca/back-end:master/source'; load: ('Deployment'). SmalltalkImage current closeSourceFiles; openSourceFiles; snapshot: true andQuit: true."

CMD ["./pharo", "Pharo.image", "cosmos", "--port=8090", "--allowed-origins=http://localhost:7080"]
