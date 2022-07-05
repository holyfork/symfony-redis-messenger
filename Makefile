test:
	vendor/bin/phpunit -v

docker-clean:
	docker stop redis || true
	docker stop redis_cluster || true
	docker stop redis_sentinel || true
	docker network remove redis || true

docker-network:
	docker network create redis --driver bridge || true

docker-redis: docker-network
	docker \
		run \
		--name redis \
		-it \
		--rm \
		--network=redis \
		-p 6379:6379 \
		redis:6.0.0

docker-redis-cluster: docker-network
	docker \
		run \
		--name redis_cluster \
		-it \
		--rm \
		--network=redis \
		-e STANDALONE=1 \
		-p 7000:7000 \
		-p 7001:7001 \
		-p 7002:7002 \
		-p 7003:7003 \
		-p 7004:7004 \
		-p 7005:7005 \
		-p 7006:7006 \
		grokzen/redis-cluster:5.0.4


docker-redis-sentinel: docker-network
	docker \
		run \
		--name redis_sentinel \
		-it \
		--rm \
		--network=redis \
		-e REDIS_MASTER_HOST=redis \
		-e REDIS_MASTER_SET=mymaster \
		-e REDIS_SENTINEL_QUORUM="1" \
		-p 26379:26379 \
		bitnami/redis-sentinel:6.0