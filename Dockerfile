FROM laradock/workspace:1.9-71

LABEL maintainer="g9308370@hotmail.com"

#####################################
# php test extension
#####################################

RUN apt-get update && \
    apt-get install -y --allow-downgrades --allow-remove-essential \
    --allow-change-held-packages \
    php7.1-xdebug


#####################################
# php cs fixer
#####################################

RUN composer global require friendsofphp/php-cs-fixer
RUN echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bashrc

#####################################
# php codesniffer
#####################################

RUN composer global require squizlabs/php_codesniffer \
    && ln -s ~/.composer/vendor/squizlabs/php_codesniffer/bin/phpcs /usr/local/bin/phpcs \
    && ln -s ~/.composer/vendor/squizlabs/php_codesniffer/bin/phpcbf /usr/local/bin/phpcbf

#####################################
# Node / Yarn / Commitizen:
#####################################

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get update && \
    apt-get install -y --allow-downgrades --allow-remove-essential \
    --allow-change-held-packages \
    nodejs \
    yarn

RUN yarn global add commitizen cz-conventional-changelog standard-version

#####################################
# Final touch:
#####################################

# Clean up
USER root
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apk/* \
    npm config set python /usr/bin/python2.7

# Set default work directory
WORKDIR /var/www