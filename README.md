# Docker Debian with rbenv and nodenv

DockerHub: https://hub.docker.com/r/amkisko/debian-rbenv-nodenv

## Usage

```dockerfile
FROM amkisko/debian-rbenv-nodenv

RUN nodenv install 16.0.0
RUN rbenv install 3.1.0 

RUN echo "Hello!"
```
