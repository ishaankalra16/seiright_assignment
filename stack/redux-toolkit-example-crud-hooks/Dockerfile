# Use an official Node.js runtime as a parent image
FROM node:18

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json for dependencies installation
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the application code
COPY . .

EXPOSE 8080

# Command to run your app
CMD ["npm", "start"]