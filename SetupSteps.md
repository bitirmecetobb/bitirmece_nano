# bitirmece_nano

## genel bilgi: 


### ubuntu: 18.04


### kernel: 4.9.253-tegra


### opencv: 4.9.0


### python: 3.8


### username: bitirmece


### password: ele2024


not: herhangi bir driver aratirken bu bilgiler de verilerek aratilmalidir.



### WIFI MODULU:
802.11n REALTEK

https://askubuntu.com/questions/1493728/unable-to-install-the-rtl8188fu-wifi-adapter-driver-on-my-jetson-nano-4gb


### Komutlar:

sudo apt-get install build-essential git dkms

git clone https://github.com/kelebek333/rtl8188fu

sudo dkms install ./rtl8188fu

sudo cp ./rtl8188fu/firmware/rtl8188fufw.bin /lib/firmware/rtlwifi/

sudo reboot



## VNC SETUP:

https://developer.nvidia.com/embedded/learn/tutorials/vnc-setup 

Bu linkteki adımlar izlenerek yapıldı.

Windows tarafında realvnc kuruldu.

### Jetson tarafında ifconfig ile ip öğrenildi:

Komut sonucu:
...
wlan0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.1.93  netmask 255.255.255.0  broadcast 192.168.1.255
        inet6 fe80::8b6f:51a0:98a4:2df3  prefixlen 64  scopeid 0x20<link>
...


Burada ip 192.168.1.93

bu ip ile windowstan vnc serverdan bağlanıldı.

not: 2 bilgisayarın da aynı wifi serverına bağlanması gerekiyor.

windows tarafindan baglanirken:

nmcli d wifi connect Hi_Baby password marmara2020

path ekleme:

Open your HOME folder

Go to View > Show Hidden Files or press Ctrl + H

Right click on .profile and click on Open With Text Editor

Scroll to the bottom and add PATH="$PATH:/my/path/foo"

Save

Log out and log back in to apply changes (let Ubuntu actually load .profile)

$ echo $PATH


### Python 3.8 versionuna geçiş:

default olarak 2.7.17 ve 3.6.9 kurulu ama biz 3.8 ile çalışmak istiyoruz


### Komutlar:

$ sudo apt install python3.8 

$ sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1 

$ sudo update-alternatives --set python /usr/bin/python3.8

Bunları python yerine python3 yazarak yapıldığında python3 versionu da değişir.

sonuçta: python3 --version ve python --version

Python 3.8.0

sonucunu vermeli.


### pip3 install:

$ sudo apt install python3-pip

$ pip --version

$ pip install wheel setuptools pip --upgrade

pip kullanırken çok sıkıntı yaşandı. 

sudo apt-get install python3.8-dev

pip install psutil

tekrar indirmek:

python3.8 -m pip install --upgrade --force-reinstall pip 


### OpenCV indirilmesi:

$ sudo apt update

$ sudo apt install python3-opencv 

$ python3 -c "import cv2; print(cv2.__version__)"

3. komut ile kontrol edilir


### Yapay zeka kısmı için ultralytics indirilmesi:

$ pip install ultralytics

Burada pip hatalarından dolayı sorunlar oldu


### Mobil uygulama tarafı:

https://medium.com/cits-tech/python-ile-firebase-firestore-database-kullan%C4%B1m%C4%B1-f4b2793eab6d

buradaki adımlar uygulanmakta.
