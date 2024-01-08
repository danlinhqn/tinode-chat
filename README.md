# Cách chạy nhanh 
docker-compose up -d

# Cách cài đặt từ Docker từng bước chạy lệnh sau ---------------------------------------------------------------------- /
docker network create tinode-net

docker run --name mongodb --network tinode-net --restart always -d mongo:4.4 --replSet "rs0"

docker exec -it mongodb mongo
rs.initiate( {"_id": "rs0", "members": [ {"_id": 0, "host": "mongodb:27017"} ]} )
quit()

# Sau đó chạy lệnh để Build Image trên docker localhost 

docker build -t tinode-chat:v01 -f Dockerfile .
docker run -p 6060:6060 -d --name tinode-srv --network tinode-net tinode-chat:v01

# Chú ý

# Các file video, hay file upload, mặc định sẽ được lưu trong source code tại mục upload như hình dưới
/opt/tinode # ls
config.template     data.json           init-db             keygen              static              tinode              uploads
credentials.sh      entrypoint.sh       init-db-stdout.txt  save                templ               tinode.conf         working.config
# Vì thế mỗi lần build lại thư mục uploads sẽ bị mất, đang tìm cách upload lên S3, đã cầu hình như hướng dẫn, nhưng chưa được

# ------------------------------------------------------------------------------------------------------- /

# Còn hình ảnh sẽ được lưu trong Database Mongodb theo dạng mã hóa ..64

https://github.com/massgravel/Microsoft-Activation-Scripts/releases
