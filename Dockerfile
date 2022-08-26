FROM quay.io/operator-framework/ansible-operator-2.11-preview:v1.16

COPY requirements.yml ${HOME}/requirements.yml
RUN ansible-galaxy collection install -r ${HOME}/requirements.yml \
 && chmod -R ug+rwx ${HOME}/.ansible

COPY watches.yaml ${HOME}/watches.yaml
COPY roles/ ${HOME}/roles/
COPY playbooks/ ${HOME}/playbooks/

#Add OCP CLI - need to add as root since it's in /usr/local/bin
#After install switch back to user 1001 so we aren't running as root
USER root
RUN curl -sLo /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.8.7/openshift-client-linux-4.8.7.tar.gz && \
    tar xzvf /tmp/oc.tar.gz -C /usr/local/bin/ && rm /tmp/oc.tar.gz
USER 1001
CMD ["/usr/local/bin/oc"]

#Create the masconfig directory to store config information needed for mas, mongo, sls
#this will be the directory used in those roles
RUN bash -c 'mkdir -p ~/masconfig'
RUN bash -c 'chmod 775 ~/masconfig'
