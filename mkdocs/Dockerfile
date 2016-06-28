FROM centos:centos7

MAINTAINER swfz <sawafuji.09@gmail.com>

RUN yum install -y gcc openssl-devel python3 wget scl-utils which
#RUN yum install -y python-setuptools gcc openssl-devel

RUN wget https://www.softwarecollections.org/en/scls/rhscl/python33/epel-7-x86_64/download/rhscl-python33-epel-7-x86_64.noarch.rpm
RUN yum install -y rhscl-python33-*.rpm
RUN yum install -y python33

#RUN wget https://pypi.python.org/packages/source/d/distribute/distribute-0.7.3.zip
#RUN unzip distribute-0.7.3.zip
#RUN cd distribute-0.7.3
#RUN python3 setup.py install

RUN easy_install pip

RUN pip install mkdocs



WORKDIR /docs/sample

VOLUME /docs/sample

EXPOSE 8000

ENTRYPOINT ["mkdocs"]

CMD ["-h"]
