#!/bin/bash

###
# Инициализируем бд
###

# sudo docker-compose down -v  

# sudo docker-compose up -d
   


sudo docker compose exec -T configSrv mongosh --port 27017  --quiet <<EOF
rs.initiate(
  {
    _id : "config_server",
    configsvr: true,
    members: [
      { _id :  0, host : "configSrv:27017" }
    ]
  }
);
exit(); 
EOF

sleep 5

sudo docker compose exec -T  shard1 mongosh --port 27018 --quiet <<EOF

rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 1, host : "shard1:27018" },
        { _id : 2, host : "shard11:27021" },
        { _id : 3, host : "shard12:27022" },
        { _id : 4, host : "shard13:27023" },
      ]
    }
);
rs.status() 
exit();
EOF

sleep 5

sudo docker compose exec -T   shard2 mongosh --port 27019 --quiet <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 5, host : "shard2:27019" },
        { _id : 6, host : "shard21:27024" },
        { _id : 7, host : "shard22:27025" },
        { _id : 8, host : "shard23:27026" },

      ]
    }
  );
rs.status() 
exit();
EOF

sleep 5

sudo docker compose exec -T  mongos_router mongosh --port 27020 --quiet <<EOF
sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
use somedb
for(var i = 0; i < 1200; i++) db.helloDoc.insert({age:i, name:"ly"+i})
db.helloDoc.countDocuments() 
exit();
EOF

sleep 15

sudo docker compose exec -T  shard1 mongosh --port 27018 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

sleep 5

sudo docker compose exec -T  shard2 mongosh --port 27019 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
