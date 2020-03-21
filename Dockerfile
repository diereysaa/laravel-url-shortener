FROM php:7.4-alpine

RUN apk add --no-cache git jq moreutils
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer create-project --prefer-dist laravel/laravel example && \
    cd example

WORKDIR /example

COPY . /laravel-url-shortener
RUN jq '.repositories=[{"type": "path","url": "/laravel-url-shortener"}]' ./composer.json | sponge ./composer.json

RUN composer require arietimmerman/laravel-url-shortener @dev

RUN touch ./.database.sqlite && \
    echo "DB_CONNECTION=sqlite" >> ./.env && \
    echo "DB_DATABASE=./.database.sqlite" >> ./.env

CMD php artisan serve