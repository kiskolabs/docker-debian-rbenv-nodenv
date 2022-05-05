# Docker Debian with rbenv and nodenv

DockerHub: https://hub.docker.com/r/amkisko/debian-rbenv-nodenv

## Usage

```dockerfile
FROM amkisko/debian-rbenv-nodenv

RUN apt-get -q update
RUN echo "Hello!"
```
