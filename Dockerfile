FROM ubuntu:22.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
  curl git unzip xz-utils zip libglu1-mesa nginx

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable Flutter web support only
RUN flutter config --enable-web

# Avoid android/ios detection
ENV FLUTTER_WEB=true
ENV ANDROID_SDK_ROOT=""
ENV PUB_CACHE="/flutter/.pub-cache"

# Copy entire repo into container
WORKDIR /app
COPY . .

# Go into your frontend directory
WORKDIR /app/breakeven_frontend_web

# Debug check: show contents
RUN ls -la && cat pubspec.yaml

# Run pub get (should now work)
RUN flutter pub get

# Build for web only
RUN flutter build web --release

# Move web build into nginx folder
RUN rm -rf /var/www/html/*
RUN cp -r build/web/* /var/www/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]