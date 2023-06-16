#!/bin/bash
set -eof pipefail
export PGPASSWORD=${POSTGRES_PASSWORD}

echo ATLAS_RESET_SCHEMA $ATLAS_RESET_SCHEMA

if [ "$ATLAS_RESET_SCHEMA" = true ];then
    psql -d ${POSTGRES_DB} -U ${POSTGRES_USER} -h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -t -c "DROP SCHEMA IF EXISTS atlas CASCADE"
    psql -d ${POSTGRES_DB} -U ${POSTGRES_USER} -h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -t -c "DROP SCHEMA IF EXISTS synthese CASCADE"
fi

schema_atlas_exists=$(psql -d ${POSTGRES_DB} -U ${POSTGRES_USER} -h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -t -c "SELECT exists(select schema_name FROM information_schema.schemata WHERE schema_name = 'atlas');" | sed 's/ //g')
if [ ! "$schema_atlas_exists" = "t" ]; then
    echo "Schema atlas inexistant ($schema_atlas_exists)"
    if [ "$ATLAS_INSTALL_SCHEMA" = true ] || [ "$ATLAS_RESET_SCHEMA" = true ] ;then
        echo Installation du schema de l''atlas
        echo ATLAS_ALTITUDES $ATLAS_ALTITUDES
        ./docker_install_atlas_schema.sh
    else
        echo Pour installer la db avec cette commande veuillez definir la variable d''environnement ATLAS_INSTALL_SCHEMA=true
        exit 1
    fi
else
    echo Schema atlas déjà installé
fi

# lance l'application gunicorn
echo Lancement de l''application atlas
gunicorn "atlas.wsgi:create_app()" --name=geonature-atlas --bind=0.0.0.0:8080 --access-logfile=- --error-logfile=-
