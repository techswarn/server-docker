run_mode=$1
echo $run_mode

function client(){
  echo "Deploy script start"
  cd ./client
  echo "In folder: "
  pwd
  docker build -t swarntech/client:latest . --platform=linux/amd64
  docker tag swarntech/client:latest registry.digitalocean.com/swarn-registry/client
  echo "Client build complete"
  echo "push to remote client"
  docker push registry.digitalocean.com/swarn-registry/client
  echo "Client push complete"
}

function server(){
  cd ./server
  echo "In folder: "
  pwd
  docker build -t swarntech/server:latest . --platform=linux/amd64
  docker tag swarntech/server:latest registry.digitalocean.com/swarn-registry/server
  echo "Server build complete"
  echo "push to remote server"
  docker push registry.digitalocean.com/swarn-registry/server
  echo "Server push complete"
}
if [ $run_mode = "client" ] 
then 
    client
elif [ $run_mode = "server" ]
then
    server
elif [ $run_mode = "both" ]
then
  echo "Deploy script start"
  cd ./client
  echo "In folder: "
  pwd
  docker build -t swarntech/client:latest . --platform=linux/amd64
  docker tag swarntech/client:latest registry.digitalocean.com/swarn-registry/client
  echo "Client build complete"
  cd ./../server
  echo "In folder: "
  pwd
  docker build -t swarntech/server:latest . --platform=linux/amd64
  docker tag swarntech/server:latest registry.digitalocean.com/swarn-registry/server
  echo "Server build complete"
  cd ./../client
  echo "push to remote client"
  docker push registry.digitalocean.com/swarn-registry/client
  cd ./../server
  echo "change dir to server and wait for a while"
  sleep 5
  echo "push to remote server"
  docker push registry.digitalocean.com/swarn-registry/server
  echo "script complete!!"
fi