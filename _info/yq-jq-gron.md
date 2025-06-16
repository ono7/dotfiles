## working with yaml, json and gron

### convert yaml to json

`cat docker-compose.yml | yq`

### convert yaml to json to gron

`cat docker-compose.yml | yq | gron`

### grep using ripgrep

`cat docker-compose.yml | yq | gron | rg "\d{1,3}"`
