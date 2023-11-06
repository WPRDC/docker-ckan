#!/usr/bin/env bash

orgs_len=$(ckanapi action organization_list | jq '. | length')
groups_len=$(ckanapi action group_list | jq '. | length')
datasets_len=$(ckanapi action package_list | jq '. | length')

# Organizations
if [ "$orgs_len" -lt 5 ]; then
  ckanapi load organizations -I /tmp/fixtures/organizations.jsonl -c $CKAN_INI
fi

# Topics
if [ "$groups_len" -lt 5 ]; then
  ckanapi load groups -I /tmp/fixtures/topics.jsonl -c $CKAN_INI
fi

# Datasets
#if [ "$datasets_len" -lt 10 ]; then
#  ckanapi load datasets -I /tmp/fixtures/datasets.jsonl -p 4 -c $CKAN_INI
#fi

# Resources
# todo: sprinkle some example resources in some datasets


# TODO: add a fake org and dataset with a csv resource for testing datatsore
