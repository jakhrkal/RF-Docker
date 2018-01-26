FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y python-pip python-dev gcc firefox xvfb wget
RUN pip install robotframework
RUN pip install robotframework-sshlibrary
RUN pip install robotframework-selenium2library
RUN pip install robotframework-xvfb

#============
# GeckoDriver
#============
ARG GECKODRIVER_VERSION=latest
RUN GK_VERSION=$(if [ ${GECKODRIVER_VERSION:-latest} = "latest" ]; then echo $(wget -qO- "https://api.github.com/repos/mozilla/geckodriver/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([0-9.]+)".*/\1/'); else echo $GECKODRIVER_VERSION; fi) \
  && echo "Using GeckoDriver version: "$GK_VERSION \
  && wget --no-verbose -O /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v$GK_VERSION/geckodriver-v$GK_VERSION-linux64.tar.gz \
  && rm -rf /opt/geckodriver \
  && tar -C /opt -zxf /tmp/geckodriver.tar.gz \
  && rm /tmp/geckodriver.tar.gz \
  && mv /opt/geckodriver /opt/geckodriver-$GK_VERSION \
  && chmod 755 /opt/geckodriver-$GK_VERSION \
&& ln -fs /opt/geckodriver-$GK_VERSION /usr/bin/geckodriver

#ADD xvfb_init /etc/init.d/xvfd
#RUN chmod a+x /etc/init.d/xvfb
#ADD xvfb-daemon-run /usr/bin/xvfb-daemon-run
#RUN chmod a+x /usr/bin/xvfb-daemon-run
#RUN git clone ssh://<USER>@<GIT_REPO>/<PATH> TODO use instead of copy
RUN mkdir /robot
COPY . /robot
WORKDIR /robot
RUN chmod a+x /robot/run-smoke.sh
RUN /robot/run-smoke.sh