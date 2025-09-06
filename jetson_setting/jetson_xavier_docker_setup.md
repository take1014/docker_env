# Jetson Xavier 用 Docker + SDK Manager セットアップ手順

この手順では、Ubuntu 24.04 ホストに Docker を使って Jetson Xavier に JetPack 5.1.5 をフラッシュする方法をまとめています。

---

## 1. 前提条件

- ホスト OS: Ubuntu 24.04  
- Docker インストール済み  
- Jetson Xavier が USB-C ケーブルで接続可能  
- Docker イメージ: `sdkmanager:2.3.0.12626-Ubuntu_20.04`  

---

## 2. Docker デーモン確認

```bash
sudo systemctl status docker
```

- `active (running)` であることを確認  
- 起動していなければ：
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

- 権限が必要な場合：
```bash
sudo usermod -aG docker $USER
newgrp docker
```

---

## 3. Docker イメージの準備

- NVIDIA SDK Manager Docker 版をダウンロード：
[https://developer.nvidia.com/sdk-manager](https://developer.nvidia.com/sdk-manager)

- ダウンロードしたイメージをロード：
```bash
docker load -i [ダウンロードフォルダ]/sdkmanager-2.3.0.12626-Ubuntu_20.04_docker.tar.gz
```

- イメージが存在するか確認：
```bash
docker images
```

---

## 4. Xavier をリカバリーモードで接続

1. Xavier の電源を切る  
2. **Force Recovery ボタンを押しながら電源 ON**  
3. USB-C ケーブルでホスト PC に接続  
4. 接続確認：
```bash
lsusb | grep NVIDIA
```
- "NVIDIA Corp." が表示されれば接続成功

---

## 5. ホストの SDK Manager を削除（干渉防止）

```bash
sudo apt remove sdkmanager
hash -r
```

---

## 6. Docker 内で SDK Manager CLI のヘルプ確認

```bash
docker run -it --rm \
  --privileged \
  --net=host \
  --device /dev/bus/usb:/dev/bus/usb \
  sdkmanager:2.3.0.12626-Ubuntu_20.04 \
  --help
```

---

## 7. JetPack 5.1.5 を Xavier にフラッシュ

```bash
docker run -it --privileged \
  --net=host \
  -v /dev/bus/usb:/dev/bus/usb \
  -v /dev:/dev \
  -v /media/$USER:/media/nvidia:slave \
  --name JetPack_Xavier_Devkit \
  sdkmanager:2.3.0.12626-Ubuntu_20.04 \
  --cli \
  --action install \
  --login-type devzone \
  --product Jetson \
  --target-os Linux \
  --version 5.1.5 \
  --target JETSON_AGX_XAVIER \
  --flash all \
  --license accept \
  --stay-logged-in true \
  --collect-usage-data enable \
  --exit-on-finish
```

### オプション解説

- `--privileged`：USB デバイスへのフルアクセス  
- `--net=host`：ホストのネットワークを利用  
- `-v /dev/bus/usb:/dev/bus/usb`：Xavier への USB 接続  
- `--cli install`：CLI モードでインストール  
- `--flash all`：OS + SDK + ドライバすべてをフラッシュ  

---

## 8. 注意事項

- ネットワーク接続必須（追加パッケージダウンロード用）  
- Xavier はリカバリーモードで接続  
- Docker 内 CLI のみで操作すること  
- CLI 認証には NVIDIA Developer アカウントが必要

