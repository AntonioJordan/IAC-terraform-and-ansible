
Vamos a montar esta arquitectura con Terrarom + Ansible.

<img src="./image.webp" alt="Ansible Core" width="400">

Para poder lanzarlo:

    - Abrir terminal - .\terraform\env\us-east-1\dev
        - terraform init
        - terraform apply
              - Te va a pedir 2 valores de claves kms escribelos en terminal. Lo que quieras password random.
  
    - Ansible se instala solo, te va a lanzar el deploy de dev. El resto de entornos no estan hechos.
                - Por cada commit nuevo para relanzar playbook:
                - sudo -i
                - cd /home/ec2-user/IAC-terraform-and-ansible
                - sudo git pull
                - ansible-playbook -i ansible/inventories/aws/dev/aws_ec2.yaml ansible/playbooks/aws/deploy.yaml
