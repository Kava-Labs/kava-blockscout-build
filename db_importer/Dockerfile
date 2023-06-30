FROM base

WORKDIR /app

# Copy scripts
COPY ./import.sh ./pre_import.sql ./post_import.sql ./

# Copy tests
COPY ./t ./t

# Voulme for SQL file to import
VOLUME [ "/import" ]
CMD ["./import.sh"]
