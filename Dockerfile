FROM dart:stable
WORKDIR /app
RUN apt-get update && apt-get install -y libsqlite3-dev
COPY pubspec.* ./
RUN dart pub get
COPY . .
ENV PORT=8080
EXPOSE 8080
CMD ["dart", "bin/main.dart"]
