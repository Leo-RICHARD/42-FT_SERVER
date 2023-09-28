CREATE DATABASE wordpressdb;
CREATE USER "username" IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpressdb.* TO 'username';
FLUSH PRIVILEGES;
