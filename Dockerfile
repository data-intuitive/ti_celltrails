FROM dynverse/dynwrap:bioc

LABEL version 0.1.0

RUN R -e 'devtools::install_github("dcellwanger/CellTrails")'

ADD . /code
ENTRYPOINT Rscript /code/run.R
