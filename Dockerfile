FROM ubuntu:bionic

# Set up environment
ENV LANG C.UTF-8
WORKDIR /srv

# System dependencies
RUN apt-get update && apt-get install --yes nginx

# Set git commit ID
ARG TALISKER_REVISION_ID
RUN test -n "${TALISKER_REVISION_ID}"

# Copy over files
ADD build .
ADD nginx.conf /etc/nginx/sites-enabled/default
ADD redirects.map /etc/nginx/redirects.map
RUN sed -i "s/~TALISKER_REVISION_ID~/${TALISKER_REVISION_ID}/" /etc/nginx/sites-enabled/default
RUN sed -i "s/8205/80/" /etc/nginx/sites-enabled/default

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
