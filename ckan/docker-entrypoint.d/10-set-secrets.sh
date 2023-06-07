echo "Setting beaker.session.secret in ini for real this time."
ckan config-tool $CKAN_INI "beaker.session.secret=$CKAN___BEAKER__SESSION__SECRET"
ckan config-tool $CKAN_INI "api_token.jwt.encode.secret=$CKAN___API_TOKEN__JWT__ENCODE__SECRET"
ckan config-tool $CKAN_INI "api_token.jwt.decode.secret=$CKAN___API_TOKEN__JWT__DECODE__SECRET"

echo "Set up ckan.datapusher.api_token with new secrets"
ckan config-tool $CKAN_INI "ckan.datapusher.api_token=$(ckan -c $CKAN_INI user token add ckan_admin datapusher | tail -n 1 | tr -d '\t')"