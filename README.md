# Docker Debian with rbenv and nodenv

Image: https://hub.docker.com/r/kiskolabs/debian-rbenv-nodenv

## Usage

```dockerfile
FROM kiskolabs/debian-rbenv-nodenv

RUN nodenv install 16.0.0
RUN rbenv install 3.1.0 

RUN echo "Hello!"
```
