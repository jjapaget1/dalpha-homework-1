docker build -t dalpha-homework:latest .

docker images | grep dalpha-homework

docker run -itd --name dalpha-homework -v ${PWD}:/workspace dalpha-homework:latest