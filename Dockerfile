FROM node:6-slim
LABEL maintainer="sebastianplaza@gmail.com"

# Install instant client and clean unused packages after
RUN apt-get update \
  && apt-get install -y libaio1 vim unzip wget \
  && mkdir -p /opt/oracle \
  && wget https://raw.githubusercontent.com/sebaplaza/node-oracle/master/oracle/linux/instantclient-basiclite-linux.x64-12.2.0.1.0.zip \
  && wget https://raw.githubusercontent.com/sebaplaza/node-oracle/master/oracle/linux/instantclient-sdk-linux.x64-12.2.0.1.0.zip \
  && unzip "*.zip" -d /opt/oracle \
  && mv /opt/oracle/instantclient_12_2 /opt/oracle/instantclient \
  && ln -s /opt/oracle/instantclient/libclntsh.so.12.1 /opt/oracle/instantclient/libclntsh.so \
  # Clean everything
  && rm *.zip \
  && apt-get remove -y --purge wget unzip \
  && apt-get autoremove -y --purge \
  && apt-get clean

ENV LD_LIBRARY_PATH="/opt/oracle/instantclient"
ENV OCI_HOME="/opt/oracle/instantclient"
ENV OCI_LIB_DIR="/opt/oracle/instantclient"
ENV OCI_INC_DIR="/opt/oracle/instantclient/sdk/include"

RUN echo '/opt/oracle/instantclient/' | tee -a /etc/ld.so.conf.d/oracle_instant_client.conf && ldconfig