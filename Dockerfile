FROM crystallang/crystal:0.29.0

WORKDIR /app

ADD https://github.com/joshdvir/reflex/releases/download/v0.3.0/reflex_0.3.0_Linux_64-bit.deb /tmp/
RUN dpkg -i /tmp/reflex_0.3.0_Linux_64-bit.deb && rm -fr /tmp/reflex_0.3.0_Linux_64-bit.deb

COPY shard.* /app/
RUN shards install

COPY . /app

CMD ["bash"]
