FROM scratch

COPY dist/udpserver /udpserver

CMD ["/udpserver"]
