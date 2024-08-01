# Stage 1: Build the application
FROM gradle:7.6.1-jdk17 AS build
WORKDIR /app
COPY build.gradle settings.gradle ./
COPY src src
RUN gradle build --no-daemon -x test
RUN ls /app/build/libs/ # JAR 파일이 제대로 생성되었는지 확인

# Stage 2: Create the final Docker image
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/build/libs/api_server-0.0.1-SNAPSHOT.jar app.jar
RUN ls /app # 최종 이미지에서 파일이 제대로 복사되었는지 확인
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
EXPOSE 8080