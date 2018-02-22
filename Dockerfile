# Use an official Linux 64 Python runtime as a parent image
FROM ubuntu:latest
LABEL maintainer="Ignasi Andres <ignasi@ime.usp.br>"
LABEL description="Docker to run NAOQi."


# Create the home directory for the new app user.
RUN mkdir -p /home/app

# Create an app user so our program doesn't run as root.
RUN groupadd -r app &&\
    useradd -r -g app -d /home/app -s /sbin/nologin -c "Docker image user" app

# Set the home directory to our app user's home.
ENV HOME=/home/app
ENV APP_HOME=/home/app/workspace

## SETTING UP THE APP ##
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

#install libraries needed
RUN apt-get -y update && apt-get -y install libglib2.0-0 libdbus-1-3

# Make port 9559 available to the world outside this container
EXPOSE 80
EXPOSE 9559

# Copy in the application code.
ADD . $APP_HOME

# Chown all the files to the app user.
RUN chown -R app:app $APP_HOME && chmod +x $APP_HOME/start.sh

# Change to the app user.
USER app

#ENTRYPOINT [naoqi-bin]
CMD ./start.sh
