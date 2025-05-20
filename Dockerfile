FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
  curl git unzip xz-utils zip libglu1-mesa nginx

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable web support
RUN flutter config --enable-web

# Set working directory to your Flutter subproject
WORKDIR /app/breakeven_frontend_web

# Copy only the Flutter app subdirectory
COPY breakeven_frontend_web /app/breakeven_frontend_web

# Get Flutter dependencies and build web
RUN flutter pub get
RUN flutter build web --release

# Serve via nginx
RUN rm -rf /var/www/html/*
RUN cp -r build/web/* /var/www/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
