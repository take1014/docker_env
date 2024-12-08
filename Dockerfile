# ベースイメージ(CUDA)の指定
FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y python3-pip python3-venv git nano

# 作業ディレクトリを設定
WORKDIR /app

# アプリケーションコードをコピー
COPY . /app

# Python仮想環境の作成
RUN python3 -m venv /app/.venv

# 仮想環境をアクティベートするコマンドを.bashrcに追加
RUN echo "source /app/.venv/bin/activate" >> /root/.bashrc

# PyTorchのインストール
RUN /app/.venv/bin/pip install torch==2.2.2 torchvision==0.17.2 torchaudio==2.2.2 --index-url https://download.pytorch.org/whl/cu121

# コンテナの起動時にbashを実行
CMD ["/bin/bash"]
