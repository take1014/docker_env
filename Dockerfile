# base image
FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

# install packages
RUN apt-get update && apt-get install -y python3-pip python3-dev python3-venv curl git vim tmux

# woriking directory
WORKDIR /app

# copy application codes
# COPY . /app

# pip install libraries
# pytorch
RUN pip install torch==2.2.2 torchvision==0.17.2 torchaudio==2.2.2 --index-url https://download.pytorch.org/whl/cu121
# others
RUN pip install pyyaml hydra-core natsort tqdm onnx onnxruntime

# vim
RUN apt-get install -y libncurses5-dev libx11-dev libxtst-dev libxt-dev libsm-dev libxpm-dev silversearcher-ag
RUN git clone https://github.com/take1014/configuration
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN cp configuration/linux/.vimrc ~/
RUN vim -c PlugInstall -c q -c q!
RUN mkdir ~/.vim/colors
RUN cp ~/.vim/plugged/jellybeans.vim/colors/jellybeans.vim ~/.vim/colors/
RUN cp configuration/linux/.tmux.conf ~/
RUN rm -rf configuration

CMD ["/bin/bash"]
