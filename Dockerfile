ARG RUBY_VERSION=2.7.5

FROM ruby:$RUBY_VERSION-alpine AS base

ARG RUBYGEMS_VERSION=3.2.3
ARG BUNDLER_VERSION=2.3.24

RUN apk --no-cache update && apk --no-cache add  \
    acl bash build-base curl gcompat imagemagick openjdk17-jre \
    libjpeg-turbo libpng libwebp ffmpeg tiff mediainfo perl libheif ghostscript \
    ruby-dev tzdata nodejs yarn zip postgresql-dev git libxml2 libxml2-dev libxslt-dev

# Install FITS and add to PATH
USER root
RUN mkdir -p /fits && \
    cd /fits && \
    wget https://github.com/harvard-lts/fits/releases/download/1.5.5/fits-1.5.5.zip -O fits.zip && \
    unzip fits.zip -d fits-1.5.5 && \
    rm fits.zip && \
    chmod a+x /fits/fits-1.5.5/fits.sh
ENV PATH="${PATH}:/fits/fits-1.5.5"

WORKDIR /app/doris/gpp-hyrax

# Set execute permissions for shell scripts
COPY ./docker/scripts/*.sh /app/doris/
RUN chmod +x /app/doris/*.sh

ENV PATH="/app/doris:$PATH" \
    RAILS_ROOT="/app/doris/gpp-hyrax" \
    BUNDLE_PATH="/app/bundle"

# Update RubyGems and Bundler to the specified version
COPY Gemfile* ./
RUN gem install rubygems-update -v $RUBYGEMS_VERSION  \
    && update_rubygems \
    && gem install bundler -v $BUNDLER_VERSION

ENTRYPOINT ["hyrax-entrypoint.sh"]

FROM base AS gpp-hyrax-dev

RUN bundle install

FROM base AS gpp-hyrax

ENV BUNDLE_WITHOUT="development test" \
    RAILS_SERVE_STATIC_FILES="1"

RUN bundle install

COPY . .

RUN RAILS_ENV=production SECRET_KEY_BASE=0 bundle exec rake assets:precompile

