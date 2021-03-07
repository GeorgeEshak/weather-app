# build stage
FROM node:14.13.1-alpine3.12 as build-stage
LABEL MAINTAINER Abdelrahman Hosny <abdelrahman@xware.solutions>
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
RUN npm run build

# production stage
FROM nginx:1.19.3-alpine as production-stage
COPY --from=build-stage /app/dist/index.html /usr/share/nginx/html/
COPY --from=build-stage /app/dist/css /usr/share/nginx/html/css/
COPY --from=build-stage /app/dist/img /usr/share/nginx/html/img/
COPY --from=build-stage /app/dist/js /usr/share/nginx/html/js/
COPY --from=build-stage /app/dist/fonts /usr/share/nginx/html/fonts/
COPY --from=build-stage /app/dist/favicon.ico /usr/share/nginx/html/favicon.ico
COPY --from=build-stage /app/dist/loader.css /usr/share/nginx/html/loader.css
COPY --from=build-stage /app/nginx/default.conf /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
