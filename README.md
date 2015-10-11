# Docker SimpleID

Originally inspired from bmwcarit/komenco-docker-base on github 
though I've heavily modified it.

This docker image now uses php instead of based on fedora, this
simplifies the Dockerfile. However, current requirements of SimpleID 
mean that you have to wrap the port behind an HTTPS proxy.

