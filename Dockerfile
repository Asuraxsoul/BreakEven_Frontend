FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
  curl git unzip xz-utils zip libglu1-mesa nginx

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable web support
RUN flutter config --enable-web

# Copy entire repo and set correct subdirectory
WORKDIR /app
COPY . .
WORKDIR /app/breakeven_frontend_web

# Limit platforms to web ONLY
RUN flutter create . --platforms=web

# Install dependencies and build web
RUN flutter pub get
RUN flutter build web --release

# Serve via nginx
RUN rm -rf /var/www/html/*
RUN cp -r build/web/* /var/www/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
