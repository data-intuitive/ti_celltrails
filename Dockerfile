FROM dynverse/dynwrap:bioc

RUN R -e 'devtools::install_github("dcellwanger/CellTrails")'
RUN R -e 'devtools::install_github("dynverse/dyntoy")'
RUN R -e 'devtools::install_github("trestletech/plumber")'
RUN apt-get update
RUN apt-get install -y vim
RUN apt-get install -y httpie

LABEL version 0.1.4

EXPOSE 8080
EXPOSE 8787

ADD . /code
ENTRYPOINT ["Rscript", "/code/run.R"]
