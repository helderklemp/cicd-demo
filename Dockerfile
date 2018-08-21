# FROM maven:3-jdk-8-alpine
# # speed up Maven JVM a bit
# ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
# # ----
# # Install project dependencies and keep sources
# # make source folder
# RUN mkdir -p /usr/src/app
# WORKDIR /usr/src/app
# # install maven dependency packages (keep in image)
# COPY pom.xml /usr/src/app
# COPY src /usr/src/app/src
# RUN mvn -T 1C install && rm -rf target




FROM openjdk:8-jdk-alpine
VOLUME /tmp
ARG JAR_FILE
COPY target/cicd-demo-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT [ "java","-Djava.security.egd=file:/dev/./unrandom","-jar","/app.jar" ]