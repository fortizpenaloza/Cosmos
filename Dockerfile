FROM basmalltalk/pharo:6.1 as imagebuilder

# Install curl and download pharo image
USER root
RUN apt-get update && apt-get --assume-yes --no-install-recommends install curl unzip
WORKDIR /opt/pharo

# Load the project
USER pharo
RUN curl get.pharo.org/61 | bash
COPY load-project.st .
RUN ./pharo Pharo.image st load-project.st

# Stage 2, start from a clean image
FROM basmalltalk/pharo:6.1

USER root
WORKDIR /opt/cosmos
RUN chown -R pharo:pharo /opt/cosmos

USER pharo

COPY --from=imagebuilder /opt/pharo/Pharo.image .
COPY --from=imagebuilder /opt/pharo/Pharo.changes .

CMD ["/opt/pharo/pharo", "Pharo.image", "cosmos", "--port=8090", "--allowed-origins=http://localhost:7080"]
