# Xpra Docker Base Image

## Credits
* [Eugene Yaremenko](https://github.com/JAremko/docker-x11-bridge)
* [s6-overlay](https://github.com/just-containers/s6-overlay)
* [Jocelyn Le Sage](https://github.com/jlesage/docker-baseimage-gui)

Eugene's image was my starting point, I made modificaitons to it to incorporate s6-overlay, as well as using the latest Alpine Linux and Xpra build, in order to make it a suitable base image for easily running GUI apps on a headless server, similar to Jocelyn's image, but more useful to my purposes.

## What it does
Automatically starts an [Xpra](https://xpra.org/) server, which allows you to access an application (or applications, or a whole desktop) with a web browser or over SSH (similar to X Forwarding).

## Instructions
Check .env file for default Xpra and user options. Using this image as a base, create a startup script for your application and copy it to /etc/services.d/app/run to have it automatically start, and restart if closed/crashed.

Example:
```
# Pull base image.
FROM [image id]

# Install xterm.
RUN add-pkg xterm

# Copy the start script.
COPY start /etc/services/app/run
```
## Disclaimer
I hacked this image together, I'm by no means an expert. It works for my purposes, but you very well may encounter issues.