#!/bin/bash

user=$(whoami)
#sudo -u postgres psql -c "create role $user login createdb;"
#sudo -u postgres psql -c "create database $user with owner $user;"
#psql -f 'create-db.sql'

role_check=$(sudo -u postgres psql -tAc "SELECT COUNT(*) FROM pg_roles WHERE rolname='$user'")
if [ $role_check -ne 1 ]; then
  sudo -u postgres psql -c "create role $user login createdb;"
fi

db_check=$(sudo -u postgres psql -tAc "SELECT COUNT(*) FROM pg_database WHERE datname='$user'")
if [ $db_check -ne 1 ]; then
  sudo -u postgres psql -c "create database $user with owner $user;"
fi

psql -f 'create-db.sql'
