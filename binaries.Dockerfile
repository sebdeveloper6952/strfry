FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4 AS build
WORKDIR /build
RUN apt update && apt install -y --no-install-recommends \
	git g++ make pkg-config libtool ca-certificates \
	libyaml-perl libtemplate-perl libregexp-grammars-perl libssl-dev zlib1g-dev \
	liblmdb-dev libflatbuffers-dev libsecp256k1-dev \
	libzstd-dev

COPY . .
RUN git submodule update --init
RUN make setup-golpe
RUN make clean
RUN make -j4

FROM scratch AS binaries
COPY --from=build /build/strfry strfry
