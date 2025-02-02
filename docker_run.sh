# use gpu0, name:take_torch2, memory:32GB, use_image:nvidia/cuda:pytorch2
docker run --gpus '"device=0"' --name take_torch2 --memory=32g --shm-size=16g -it -v /home/take/fun:/app/fun nvidia/cuda:pytorch2 bash
# use gpu 0, 1
# docker run --gpus '"device=0,1"' --name take_torch2 --memory=32g -it nvidia/cuda:pytorch2 bash
