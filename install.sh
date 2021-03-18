#!/bin/bash -e

# firewall-cmd --add-port=389/tcp --permanent
# firewall-cmd --add-port=636/tcp --permanent
# firewall-cmd --add-port=80/tcp --permanent
# firewall-cmd --add-port=443/tcp --permanent
# firewall-cmd --reload

# OpenLDAP
docker run \
    --name ldap-service \
    --hostname ldap-service \
    -p 389:389 \
    -p 636:636 \
	--env LDAP_ORGANISATION="zsjy2012" \
	--env LDAP_DOMAIN="zsjy2012.cn" \
	--env LDAP_ADMIN_PASSWORD="DR3RZ2e7EDVj1nxj" \
	--volume /data/slapd/database:/var/lib/ldap \
	--volume /data/slapd/config:/etc/ldap/slapd.d \
	--detach osixia/openldap:latest

# PHPLDAPAdmin
docker run \
    --name phpldapadmin-service \
    --hostname phpldapadmin-service \
    -p 443:443 \
    --link ldap-service:ldap-host \
    --env PHPLDAPADMIN_LDAP_HOSTS=ldap.zsjy2012.cn \
    --detach osixia/phpldapadmin:latest

    # --volume /data/PHPLDAPAdmin/:/container/service/phpldapadmin/assets/config/ \
    # --env PHPLDAPADMIN_LDAP_HOSTS=ldap-host \

   

PHPLDAP_IP=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" phpldapadmin-service)

echo "Go to: https://$PHPLDAP_IP"
echo "Login DN: cn=admin,dc=zsjy2012,dc=cn"
echo "Password: DR3RZ2e7EDVj1nxj"


