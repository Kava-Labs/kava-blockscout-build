FROM postgres:15.2

ENV PGTAP_VERSION v1.2.0

RUN apt-get update && apt-get install -y git build-essential

RUN git clone https://github.com/theory/pgtap \
 && cd pgtap \
 && git checkout ${PGTAP_VERSION} \
 && make \
 && make install

FROM postgres:15.2

COPY --from=0 /usr/share/postgresql/15/extension/pgtap* /usr/share/postgresql/15/extension/

RUN apt-get update && apt-get install -y \
      build-essential \
  && cpan TAP::Parser::SourceHandler::pgTAP \
  && apt-get remove -y build-essential \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
