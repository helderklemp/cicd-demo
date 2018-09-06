FROM nexus:18443/java-base:latest
VOLUME /tmp
ARG JAR_FILE
COPY target/cicd-demo-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT [ "java","-Djava.security.egd=file:/dev/./unrandom","-jar","/app.jar" ]
