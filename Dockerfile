FROM fluent/fluentd:v1.16-debian-2

USER root

RUN buildDeps="sudo make gcc g++ libc-dev" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && sudo gem install bundler \
 && sudo gem sources --clear-all \
 && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

WORKDIR /etc/fluent

RUN echo 'source "https://rubygems.org"' > Gemfile \
    && echo 'gem "fluentd"' >> Gemfile \
    && echo 'gem "fluent-plugin-aliyun-oss"' >> Gemfile \
    && echo 'gem "aliyun-sdk", "~> 0.8.0"' >> Gemfile

RUN bundle install

USER fluent
