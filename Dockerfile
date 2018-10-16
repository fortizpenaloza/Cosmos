FROM basmalltalk/pharo:6.1 as imagebuilder

# Install curl and download pharo image
USER root
RUN apt-get update && apt-get --assume-yes --no-install-recommends install curl unzip
WORKDIR /opt/pharo

# Load the project
RUN curl get.pharo.org/61 | bash
COPY load-project.st .
COPY load-project.sh .
RUN chmod a+x load-project.sh
RUN chown -R pharo:pharo /opt/pharo

USER pharo
RUN ./load-project.sh

# Stage 2, start from a clean image
FROM basmalltalk/pharo:6.1

USER root
WORKDIR /opt/cosmos

COPY --from=imagebuilder /opt/pharo/Pharo.image .
COPY --from=imagebuilder /opt/pharo/Pharo.changes .

RUN mkdir logs
RUN chown -R pharo:pharo /opt/cosmos

USER pharo

CMD ["/opt/pharo/pharo", "Pharo.image", "cosmos", "--port=8090", "--allowed-origins=http://localhost:7080"]
