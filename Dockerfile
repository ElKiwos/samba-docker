FROM ubuntu:impish

ARG version
ARG build_date

#
# TODO: volume for private
#
VOLUME ["/var/lib/samba", "/etc/samba", "/var/log/samba", "/srv/shares"]
ENV DEBIAN_FRONTEND noninteractive

#COPY smb.conf /etc/samba/smb.conf

# PKG: acl for getfacl & setfacl
# winbindd is a must for ac dc
RUN apt-get clean && apt-get update && \
    apt-get install -y attr acl samba smbclient samba-vfs-modules winbind libnss-winbind libpam-winbind \
                       openssl
RUN apt-get install -y ldap-utils ldb-tools cifs-utils smbldap-tools 
# tools for debugging
RUN apt-get install -y vim bind9-host krb5-user iputils-ping iproute2
RUN apt-get autoclean && \
    rm -rf /var/cache/apt/archives/*

# create directory for shares not needed is a volume!
#RUN mkdir -f /srv/shares

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY tools /root/tools
RUN chmod +x /root/tools/*.sh

LABEL org.label-schema.build-date=$build_date

EXPOSE 53/tcp
EXPOSE 53/udp
EXPOSE 88/tcp
EXPOSE 88/udp
EXPOSE 135/tcp
EXPOSE 137/tcp
EXPOSE 138/udp
EXPOSE 139/tcp
EXPOSE 389/tcp
EXPOSE 389/udp
EXPOSE 445/tcp
EXPOSE 464/tcp
EXPOSE 464/udp


ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["samba"]
