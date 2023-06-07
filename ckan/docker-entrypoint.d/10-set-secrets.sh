echo "Setting beaker.session.secret in ini for real this time."
ckan config-tool $CKAN_INI "beaker.session.secret=$CKAN___BEAKER__SESSION__SECRET"
ckan config-tool $CKAN_INI "api_token.jwt.encode.secret=$CKAN___API_TOKEN__JWT__ENCODE__SECRET"
ckan config-tool $CKAN_INI "api_token.jwt.decode.secret=$CKAN___API_TOKEN__JWT__DECODE__SECRET"