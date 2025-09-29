FROM gradle:8.13-jdk23 as build

ARG GRADLE_CI_FLAGS=""
ENV GRADLE_OPTS="-Xms64m -Xmx192m -Dorg.gradle.daemon=false"
ENV GRADLE_USER_HOME=/home/gradle/.gradle-keep
COPY --chown=gradle:gradle build.gradle settings.gradle /home/gradle/app/
WORKDIR /home/gradle/app
RUN gradle downloadDependencies ${GRADLE_CI_FLAGS}
COPY --chown=gradle:gradle src /home/gradle/app/src
RUN gradle -x check build ${GRADLE_CI_FLAGS} \
    && mkdir -p build/dependency \
    && unzip build/libs/*.jar -d build/dependency

FROM eclipse-temurin:25-jre-alpine

# Change the default JVM DNS cache
ARG JAVA_DNS_TTL_SECONDS=60
RUN printf "\nnetworkaddress.cache.ttl=%s\n" ${JAVA_DNS_TTL_SECONDS} >> "${JAVA_HOME}/conf/security/java.security"

RUN apk add --update curl && \
    rm -rf /var/cache/apk/*

RUN addgroup -g 1000 appuser && \
    adduser -D -u 1000 -G appuser appuser
USER appuser
WORKDIR /app
ARG DEPENDENCY=/home/gradle/app/build/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app/classes

ENTRYPOINT ["java","-cp","lib/*:classes","com.damvinod.hello.world.HelloWorldApplication"]
EXPOSE 8080