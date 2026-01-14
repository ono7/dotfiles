## working with yaml, json and gron

## json to yaml

`%!yq -y`

### convert yaml to json

`cat docker-compose.yml | yq`

### convert yaml to json to gron

`cat docker-compose.yml | yq | gron`

### grep using ripgrep

`cat docker-compose.yml | yq | gron | rg "\d{1,3}"`

### convert back to json

`cat docker-compose.yml | yq | gron | rg "\d{1,3}" | gron -u`

### filter and convert back to json

delete any lines that contain 100 from the json file and recontruct

`cat docker-compose.yml | yq | gron | rg "\d{1,3}" | sed -r "s/100\./d" | gron -u`
