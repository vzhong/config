First, install dependencies
```
pip install -r requirements.txt
```

Install on remote computer:
```
ansible-playbook -i hosts playbooks/dev.yml
```

Install on same computer:
```
ansible-playbook --connection=local -i 127.0.0.1, playbooks/dev.yml
```

Additionally for ML servers:
```
ansible-playbook -i hosts playbooks/ml.yml
```
