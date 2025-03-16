# Stage 1: Build the application
FROM gradle:8.11.1-jdk17-alpine AS build
# Switch to root to install dependencies

COPY --chown=gradle:gradle . /app
WORKDIR /app
RUN gradle build --no-daemon -x test

# Set working directory inside cloned repo
WORKDIR /app


# Stage 2: Create a lightweight image with only the built JAR
FROM openjdk:17-jdk-slim

WORKDIR /app
# Copy built JAR from builder stage
COPY --from=build /app/build/libs/*.jar /app/app.jar

# Expose the application's port
EXPOSE 9000

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
