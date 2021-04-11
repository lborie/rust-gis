launch-db:
	docker run --name=rust-gis -d \
	-e POSTGRES_DBNAME=karnott \
	-e POSTGRES_USER=karnott \
	-e POSTGRES_PASS=12345678 \
	-v $$(pwd)/resources:/workdir \
	-p 5432:5432 kartoza/postgis:latest
	docker exec -it rust-gis /bin/bash -c 'useradd karnott'
	docker exec -it rust-gis /bin/bash -c 'apt update && apt install --assume-yes postgis'

delete-db:
	docker stop rust-gis && docker rm rust-gis

import-departements:
	docker exec --user karnott -it rust-gis /bin/bash -c 'shp2pgsql -s 4326 -d -I /workdir/departements-20180101-shp/departements-20180101.shp | psql -U karnott -d karnott'

import-regions:
	docker exec --user karnott -it rust-gis /bin/bash -c 'shp2pgsql -s 4326 -d -I /workdir/regions-20180101-shp/regions-20180101.shp | psql -U karnott -d karnott'

import-sncf:
	docker exec --user karnott -it rust-gis /bin/bash -c 'shp2pgsql -s 4326 -d -I /workdir/formes-des-lignes-du-rfn/formes-des-lignes-du-rfn.shp | psql -U karnott -d karnott'

init: launch-db import-regions import-departements import-sncf
	docker exec --user karnott -it rust-gis /bin/bash -c 'cat /workdir/simplify.sql | psql -U karnott -d karnott'