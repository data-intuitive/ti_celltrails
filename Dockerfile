FROM dynverse/dynwrap:bioc

RUN R -e 'devtools::install_github("dcellwanger/CellTrails")'
RUN R -e 'devtools::install_github("dynverse/dyntoy")'

RUN apt-get install curl

RUN echo "Pulling watchdog binary & yq from Github." \
    && curl -sSL https://github.com/openfaas/faas/releases/download/0.9.14/fwatchdog > /usr/bin/fwatchdog \
    && chmod +x /usr/bin/fwatchdog \
    && cp /usr/bin/fwatchdog /opt \
    && curl -sSL https://github.com/mikefarah/yq/releases/download/2.2.1/yq_linux_386 > /usr/bin/yq \
    && chmod +x /usr/bin/yq

LABEL version 0.2.1

WORKDIR /code

RUN echo "Pulling porta.sh from Github." \
    && curl -sSL https://raw.githubusercontent.com/data-intuitive/Portash/master/porta.sh > /usr/bin/porta.sh \
    && chmod +x /usr/bin/porta.sh

ADD . /code
CMD [ "porta.sh" ]
