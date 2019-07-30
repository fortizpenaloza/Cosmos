# Stage 1, load the project on a clean pharo image
FROM basmalltalk/pharo:6.1-image as imagebuilder

USER root
WORKDIR /opt/pharo

COPY load-project.st .
RUN chown -R pharo:pharo /opt/pharo
USER pharo
RUN ./pharo Pharo.image st load-project.st

# Stage 2, start from a clean image
FROM basmalltalk/pharo:6.1

USER root
WORKDIR /opt/cosmos

# Copy image and changes from previous stage
COPY --from=imagebuilder /opt/pharo/Pharo.image .
COPY --from=imagebuilder /opt/pharo/Pharo.changes .

RUN mkdir logs
RUN chown -R pharo:pharo /opt/cosmos

USER pharo

CMD ["pharo", "Pharo.image", "cosmos", "--suspend-ui", "--port=8090", "--allowed-origins=http://localhost:7080"]
