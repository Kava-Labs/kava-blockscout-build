FROM postgres:15.2
ENV PGTAP_VERSION v1.2.0

RUN apt-get update && apt-get install -y git build-essential

RUN git clone https://github.com/theory/pgtap \
 && cd pgtap \
 && git checkout ${PGTAP_VERSION} \
 && make \
 && make install

RUN apt-get update && apt-get install -y \
      build-essential \
  && cpan TAP::Parser::SourceHandler::pgTAP \
  && apt-get remove -y build-essential \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy scripts
COPY ./import.sh ./pre_import.sql ./post_import.sql ./

# Copy tests
COPY ./t ./t

# Copy any SQL file to import to embed with Docker image
COPY ./import /import/

# Voulme for SQL file to import
VOLUME [ "/import" ]
CMD ["./import.sh"]
