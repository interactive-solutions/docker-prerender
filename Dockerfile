FROM node:latest

# Add required external dependencies
RUN echo deb http://ftp.debian.org/debian/ jessie main contrib non-free > /etc/apt/source.list

# Install required dependencies
RUN apt-get update -y && apt-get install -y python2.7 python-pip libfreetype6 libfontconfig && apt-get clean

# Install prerender
RUN git clone https://github.com/prerender/prerender.git /prerender

# Install dependencies
RUN cd /prerender; npm install;

# Incase we want to link something
EXPOSE 3000

# Default command
CMD ["node", "/prerender/server.js"]
