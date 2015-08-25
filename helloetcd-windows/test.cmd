@echo off
docker build -t helloetcd .
docker run -it --name helloetcd -p 80:80 -e ETCD_PROXY=on -e ETCD_LISTEN_CLIENT_URLS=http://127.0.0.1:2379 -e "ETCD_INITIAL_CLUSTER=win2016=http://10.0.1.10:2380" helloetcd cmd
pause
docker kill helloetcd
docker rm helloetcd