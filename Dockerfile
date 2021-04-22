FROM python:3.9-buster
LABEL maintainer "Damian Ziobro <damian@xmementoit.com>"

## For geckodriver installation: curl/wget/libgconf/unzip
RUN apt-get update -y && apt-get install -y wget curl unzip libgconf-2-4
## For project usage: python3/python3-pip/chromium/xvfb
## Installing Firefox to Debian Stretch https://unix.stackexchange.com/a/406554/169768
RUN sh -c 'echo "APT::Default-Release "stable";" >> /etc/apt/apt.conf' 
RUN sh -c 'echo "deb http://ftp.hr.debian.org/debian sid main contrib non-free" >> /etc/apt/sources.list'
RUN apt-get update -y && apt-get install -yt sid firefox
RUN apt-get update -y && apt-get install -y xvfb python3 python3-pip 


# Download, unzip, and install geckodriver
RUN wget https://github.com/mozilla/geckodriver/releases/download/`curl https://github.com/mozilla/geckodriver/releases/latest | grep -Po 'v[0-9]+.[0-9]+.[0-9]+'`/geckodriver-`curl https://github.com/mozilla/geckodriver/releases/latest | grep -Po 'v[0-9]+.[0-9]+.[0-9]+'`-linux64.tar.gz
RUN tar -zxf geckodriver-`curl https://github.com/mozilla/geckodriver/releases/latest | grep -Po 'v[0-9]+.[0-9]+.[0-9]+'`-linux64.tar.gz -C /usr/local/bin
RUN chmod +x /usr/local/bin/geckodriver

# install google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable

# install chromedriver
RUN apt-get install -yqq unzip
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

# set display port to avoid crash
ENV DISPLAY=:99
