FROM ubuntu:latest
RUN apt update && \
    apt install -y git
RUN git clone https://github.com/Serophis/embedded_tools.git
WORKDIR embedded_tools/install_tools/generic_tools
RUN chmod +x install_prose_tools.sh
RUN sh install_prose_tools.sh