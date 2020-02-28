FROM ubuntu:18.04

#Install ansible
RUN apt update
RUN apt-get install -y software-properties-common
RUN apt-add-repository --yes --update ppa:ansible/ansible
RUN apt-get install -y ansible

#Install SSH
RUN apt-get update && apt-get install -y mc nano sudo openssh-server openssh-client
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Create user
RUN useradd -s /bin/bash -d /home/user/ -m -G sudo user
RUN echo "user:user" | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]