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

COPY ./export.sh export.sh

RUN mkdir -p /export

# Export volume target
VOLUME [ "/export" ]
CMD ["./export.sh"]
