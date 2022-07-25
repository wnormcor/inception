# ставим на монитор редис:
# docker exec -it cnt_redis redis-cli monitor

FROM	debian:buster

RUN		apt-get update -y 1>/dev/null 2>&1
RUN		apt-get install -y wget curl python3 vim procps net-tools 1>/dev/null 2>&1
RUN		apt-get install -y redis

RUN		mv /etc/redis/redis.conf /etc/redis/redis.conf.orig
RUN		echo "protected-mode no\n\
port 6379\n\
tcp-backlog 128\n\
unixsocket /run/redis/redis.sock\n\
unixsocketperm 770\n\
timeout 0\n\
tcp-keepalive 300\n\
supervised systemd\n\
loglevel notice\n\
logfile /var/log/redis/redis.log\n\
databases 16\n\
always-show-logo no\n\
save 900 1\n\
save 300 10\n\
save 60 10000\n\
stop-writes-on-bgsave-error yes\n\
rdbcompression yes\n\
rdbchecksum yes\n\
dbfilename dump.rdb\n\
dir /var/lib/redis\n\
replica-serve-stale-data yes\n\
replica-read-only yes\n\
repl-diskless-sync no\n\
repl-disable-tcp-nodelay no\n\
replica-priority 100\n\
maxmemory 256mb\n\
maxmemory-policy allkeys-lru\n\
lazyfree-lazy-eviction no\n\
lazyfree-lazy-expire no\n\
lazyfree-lazy-server-del no\n\
replica-lazy-flush no\n\
appendonly no\n\
appendfilename \"appendonly.aof\"\n\
appendfsync everysec\n\
no-appendfsync-on-rewrite no\n\
auto-aof-rewrite-percentage 100\n\
auto-aof-rewrite-min-size 64mb\n\
aof-load-truncated yes\n\
aof-use-rdb-preamble yes\n\
lua-time-limit 5000\n\
slowlog-log-slower-than 10000\n\
slowlog-max-len 128\n\
latency-monitor-threshold 0\n\
notify-keyspace-events \"\"\n\
hash-max-ziplist-entries 512\n\
hash-max-ziplist-value 64\n\
list-max-ziplist-size -2\n\
list-compress-depth 0\n\
set-max-intset-entries 512\n\
zset-max-ziplist-entries 128\n\
zset-max-ziplist-value 64\n\
hll-sparse-max-bytes 3000\n\
stream-node-max-bytes 4096\n\
stream-node-max-entries 100\n\
activerehashing yes\n\
client-output-buffer-limit normal 0 0 0\n\
client-output-buffer-limit replica 256mb 64mb 60\n\
client-output-buffer-limit pubsub 32mb 8mb 60\n\
hz 10\n\
dynamic-hz yes\n\
aof-rewrite-incremental-fsync yes\n\
rdb-save-incremental-fsync yes\n" > /etc/redis/redis.conf && chmod 777 /etc/redis/redis.conf

RUN		echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf
# RUN		sysctl vm.overcommit_memory=1

# sed -i "s/# maxmemory <bytes>/maxmemory 256mb/" etc/redis/redis.conf
# sed -i "s/bind 127.0.0.1/#bind 127.0.0.1/" etc/redis/redis.conf
# sed -i "s/# maxmemory-policy noeviction/maxmemory-policy allkeys-lru/" etc/redis/redis.conf
# sed -i "s/protected-mode yes/protected-mode no/" /etc/redis/redis.conf

EXPOSE	6379

CMD		["redis-server", "./", "--protected-mode", "no"]

# настройка взаимодействия с wordpress при ее обращениях к БД

# добавим еще пакетов
# https://codewithhugo.com/install-just-redis-cli-on-ubuntu-debian-jessie/ for redis-cli
# RUN		apt-get install -y redis-server

# документация и описание
# https://github.com/rhubarbgroup/redis-cache/wiki/Connection-Parameters
