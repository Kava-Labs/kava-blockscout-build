FROM base

WORKDIR /app

COPY ./export.sh export.sh

RUN mkdir -p /export

# Export volume target
VOLUME [ "/export" ]
CMD ["./export.sh"]
