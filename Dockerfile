# Stage 1: Build the application
FROM dart:stable AS build

# Install dependencies for Flutter
RUN apt-get update
RUN apt-get install -y curl git wget unzip xz-utils libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback python3
RUN apt-get clean


# Clone the Flutter repository
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set the Flutter path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Checkout the specific version of Flutter
RUN flutter channel stable
RUN flutter upgrade
RUN git -C /usr/local/flutter checkout 4145645

RUN flutter doctor

WORKDIR /app

# Copy over your app
COPY pubspec.* /app/
RUN flutter pub get
COPY . /app
RUN flutter pub get --offline
RUN flutter clean
RUN flutter build web --release --no-tree-shake-icons

# Expose port
EXPOSE 8080

# make server startup script executable and start the web server
RUN ["chmod", "+x", "/app/server/server.sh"]

ENTRYPOINT [ "/app/server/server.sh"]

