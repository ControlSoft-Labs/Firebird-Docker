#!/bin/bash
set -e

SECURITYDB=${FBPATH}/security3.fdb

title() {

    printf -v PAD %30s
    PASS=$ISC_PASSWORD$PAD

    echo
    echo
    echo "8888888                              88                                    88"  
    echo "88       88                          88           88                       88"  
    echo "88                                   88                                    88"  
    echo "88MMMMM  88  8b,dPPYba,   ,adPPYba,  88,dPPYba,   88  8b,dPPYba,   ,adPPYb,88"  
    echo "88       88  88P'    Y8  a8P_____88  88P'    \"8a  88  88P'   \"Y8  a8\"    \`Y88"  
    echo "88       88  88          8PP\"\"\"\"\"\"\"  88       d8  88  88          8b       88"  
    echo "88       88  88          \"8b,   ,aa  88b,   ,a8\"  88  88          \"8a,   ,d88"  
    echo "88       88  88           \`\"Ybbd8\"'  8Y\"Ybbd8\"'   88  88           \`\"8bbdP\"Y8"
    echo
    echo "                                                          v3.0.4.33054 stable"
    echo "                                                        Debian 10 Slim stable"
    echo
    echo "                                                      labs.controlsoft.com.br"
    echo
    echo "      ┌───────────┬───────┬────────┬───────────────────────────────┐"
    echo "      │ Host      │ Port  │ Status │ SYSDBA Pass                   │"
    echo "      ├───────────┼───────┼────────┼───────────────────────────────┤"
    echo "      │ 127.0.0.1 │ 3050  │ online │ ${PASS:0:30}│"
    echo "      └───────────┴───────┴────────┴───────────────────────────────┘"
    echo
    echo " TOOLS: (docker exec -it <container> <tool>)"
    echo "   - isql: Interactive SQL"
    echo "   - alias: Database alias creation (registerDatabase.sh)"
    echo "   - gbak: Backup and restore"
    echo "   - gfix: Database repair"
    echo "   - gstat: Database statistics"
    echo "   - fb_config: Configurations"
    echo "   - fbsvcmgr: Service API interface"
    echo "   - fbguard: Firebird Guardian service"
    echo
}
logs() {
    echo " LOGS:"
    tail -f /opt/firebird/firebird.log
}

confSet() {
    confFile="${FBPATH}/firebird.conf"
    sed -i "s/^#${1}/${1}/g" "${confFile}"
    sed -i "s~^\(${1}\s*=\s*\).*$~\1${2}~" "${confFile}"
}

createNewPassword() {
    # openssl generates random data.
    openssl </dev/null >/dev/null 2>/dev/null
    if [ $? -eq 0 ]
    then
        # We generate 40 random chars, strip any '/''s and get the first 10
        NewPasswd=`openssl rand -base64 40 | tr -d '/' | cut -c1-10`
    fi

    # If openssl is missing...
    if [ -z "$NewPasswd" ]
    then
        NewPasswd=`dd if=/dev/urandom bs=10 count=1 2>/dev/null | od -x | head -n 1 | tr -d ' ' | cut -c8-17`
    fi  

    # On some systems even this routines may be missing. So if
    # the specific one isn't available then keep the original password.
    if [ -z "$NewPasswd" ]
    then
        NewPasswd="masterkey"
    fi

    echo "$NewPasswd"
}

changePassword() {
    if [ -f "${SECURITYDB}" ]; then
        if [ -z ${PASSWORD} ]; then
            PASSWORD=$(createNewPassword)
        fi
        ${FBPATH}/bin/isql -user sysdba ${SECURITYDB} <<EOL
create or alter user SYSDBA password '${PASSWORD}' using plugin Srp;
commit;
quit;
EOL

cat > "${FBPATH}/SYSDBA.password" <<EOL
# Firebird generated password for user SYSDBA is:
#
ISC_USER=sysdba
ISC_PASSWORD=${PASSWORD}
#
# Also set legacy variable though it can't be exported directly
#
ISC_PASSWD=${PASSWORD}
#
# generated at time $(date)
#
# Your password can be changed to a more suitable one using
# SQL operator ALTER USER.
#
EOL

        if [ -f "${FBPATH}/SYSDBA.password" ]; then
            source "${FBPATH}/SYSDBA.password"
        fi;
    fi
}

configure() {
    if [[ ${WIRECRYPT} != 'false' ]]; then
        confSet WireCrypt "enabled"
    fi
    confSet RemoteAuxPort "3051"
}

addAlias() {
    if [ -L "${FBBIN}/alias" ]; then
      ln -s ${FBBIN}/registerDatabase.sh ${FBBIN}/alias
    fi
}

if [[ ${1:0:1} = '-' ]]; then
    EXTRA_ARGS="$@"
    set --
elif [[ ${1} == fbguard || ${1} == $(which fbguard) ]]; then
    EXTRA_ARGS="${@:2}"
    set --
fi

# default behaviour is to launch firebird
if [[ ${1} == fbguard ||  -z ${1} ]]; then
    changePassword
    configure
    addAlias
    title
    exec ${FBBIN}/fbguard $EXTRA_ARGS & logs
else
    exec "$@"
fi


