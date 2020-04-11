# Docker deployment of plumber API

```
docker build -t sars2packapi .
docker run -p 8080:8080 sars2packapi
```

Then, access:

http://localhost:8080/__swagger__/

