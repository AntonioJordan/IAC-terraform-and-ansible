
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
                - cd /home/ec2-user/IAC-terraform-and-ansible/  # Para ir al inventory
                - sudo git pull
                - ansible-playbook -i ansible/inventories/aws/dev/aws_ec2.yaml ansible/playbooks/aws/deploy.yaml
                - cd ansible/inventories/aws/dev  # Para ir al inventory
                - ansible-inventory -i aws_ec2.yaml --list -vvv   # Para ver que ha scrapeado, lo ideal son 2 ec2 eks y 1 ansible core
                - 
