# Stage 1, load the project on a clean pharo image
FROM basmalltalk/pharo:7.0-image as imagebuilder

USER root
WORKDIR /opt/pharo

COPY load-project.st .
RUN chown -R pharo:pharo /opt/pharo
USER pharo
RUN ./pharo Pharo.image st load-project.st --save --quit

# Stage 2, start from a clean image
FROM basmalltalk/pharo:7.0

USER root
WORKDIR /opt/cosmos

# Copy image and changes from previous stage
COPY --from=imagebuilder /opt/pharo/Pharo.image .
COPY --from=imagebuilder /opt/pharo/Pharo.changes .
COPY --from=imagebuilder /opt/pharo/Pharo*.sources ./
COPY start.sh ./start.sh

RUN mkdir logs
RUN chown -R pharo:pharo /opt/cosmos

USER pharo
VOLUME /opt/cosmos/logs


CMD ["./start.sh"]
