FROM dynverse/dynwrap:bioc

RUN R -e 'devtools::install_github("dcellwanger/CellTrails")'
RUN R -e 'devtools::install_github("dynverse/dyntoy")'
RUN R -e 'devtools::install_github("trestletech/plumber")'
RUN R -e 'install.packages("future")'
RUN R -e 'devtools::install_github("richfitz/ids", upgrade = FALSE)'
RUN R -e 'install.packages("hash")'
RUN apt-get update
RUN apt-get install -y vim
RUN apt-get install -y httpie

LABEL version 0.1.5

EXPOSE 8080
EXPOSE 8787

ADD . /code
ENTRYPOINT ["Rscript", "/code/plumb.R"]
