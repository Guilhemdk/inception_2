CALE FOR PROJECT INCEPTION

# (/PROJECTS/INCEPTION)

## You should evaluate 1 student in this team

```
Git repository
```
# Introduction

```
Please comply with the following rules:
```
- Remain polite, courteous, respectful and constructive throughout the
evaluation process. The well-being of the community depends on it.
- Identify with the student or group whose work is evaluated the possible
dysfunctions in their project. Take the time to discuss and debate the
problems that may have been identified.
- You must consider that there might be some differences in how your peers
might have understood the project's instructions and the scope of its
functionalities. Always keep an open mind and grade them as honestly as
possible. The pedagogy is useful only and only if the peer-evaluation is
done seriously.

# Guidelines

- Only grade the work that was turned in the Git repository of the evaluated
student or group.
- Double-check that the Git repository belongs to the student(s). Ensure that
the project is the one expected. Also, check that 'git clone' is used in an
empty folder.
- Check carefully that no malicious aliases was used to fool you and make you
evaluate something that is not the content of the official repository.
- To avoid any surprises and if applicable, review together any scripts used


##   (https://profile.intra.42.fr/searches) tjuliean


to facilitate the grading (scripts for testing or automation).

- If you have not completed the assignment you are going to evaluate, you have
to read the entire subject prior to starting the evaluation process.
- Use the available flags to report an empty repository, a non-functioning
program, a Norm error, cheating, and so forth.
In these cases, the evaluation process ends and the final grade is 0,
or -42 in case of cheating. However, except for cheating, student are
strongly encouraged to review together the work that was turned in, in order
to identify any mistakes that shouldn't be repeated in the future.

# Attachments

```
 subject.pdf (https://cdn.intra.42.fr/pdf/pdf/28114/en.subject.pdf)
```
# Preliminaries

If cheating is suspected, the evaluation stops here. Use the "Cheat" flag to report it. Take this decision calmly, wisely,
and please, use this button with caution.

Preliminary tests

- Defense can only happen if the evaluated student or group is present.
This way everybody learns by sharing knowledge with each other.
- If no work has been submitted (or wrong files, wrong directory, or
wrong filenames), the grade is 0, and the evaluation process ends.
- For this project, you have to clone their Git repository on their
station.

# General instructions

General instructions

- For the entire evaluation process, if you don't know how to check a
requirement, or verify anything, the evaluated student has to help you.
- Ensure that all the files required to configure the application are
located inside a srcs folder. The srcs folder must be located at the
root of the repository.
- Ensure that a Makefile is located at the root of the repository.
- Before starting the evaluation, run this command in the terminal:
"docker stop $(docker ps -qa); docker rm $(docker ps -qa);
docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q);
docker network rm $(docker network ls -q) 2>/dev/null"
- Read the docker-compose.yml file. There musn't be 'network: host' in
it or 'links:'. Otherwise, the evaluation ends now.
- Read the docker-compose.yml file. There must be 'network(s)' in it.
Otherwise, the evaluation ends now.
- Examine the Makefile and all the scripts in which Docker is used.
There musn't be '--link' in any of them. Otherwise, the evaluation
ends now.
- Examine the Dockerfiles. If you see 'tail -f' or any command run in
background in any of them in the ENTRYPOINT section, the evaluation
ends now. Same thing if 'bash' or 'sh' are used but not for running a
script (e.g, 'nginx & bash' or 'bash').
- If the entrypoint is a script (e.g., ENTRYPOINT ["sh", "my_entrypoint.sh"],
ENTRYPOINT ["bash", "my_entrypoint.sh"]), ensure it runs no program
in background (e.g, 'nginx & bash').
- Examine all the scripts in the repository. Ensure none of them runs
an infinite loop.
The following are a few examples of prohibited commands:
'sleep infinity', 'tail -f /dev/null', 'tail -f /dev/random'
- Run the Makefile.


# Mandatory part

This project consists in setting up a small infrastructure composed of different services using docker-compose. Ensure
that all the following points are correct.

Project overview

- The evaluated person has to explain to you in simple terms:
- How Docker and docker-compose work
- The difference between a Docker image used with docker-compose and
without docker-compose
- The benefit of Docker compared to VMs
- The pertinence of the directory structure required for this project
(an example is provided in the subject's PDF file).


Simple setup

- Ensure that NGINX can be accessed by port 443 only. Once done, open
the page.
- Ensure that a SSL/TLS certificate is used.
- Ensure that the WordPress website is properly installed and configured
(you shouldn't see the WordPress Installation page). To access it,
open https://login.42.fr in your browser, where login is the login of
the evaluated student. You shouldn't be able to access the site via
[http://login.42.fr.](http://login.42.fr.)
If something doesn't work as expected, the evaluation process ends now.


Docker Basics

- Start by checking the Dockerfiles. There must be one Dockerfile per
service. Ensure that the Dockerfiles are not empty files. If it's not
the case or if a Dockerfile is missing, the evaluation process ends
now.
- Make sure the evaluated student has written their own Dockerfiles and
built their own Docker images. Indeed, it is forbidden to use
ready-made ones or to use services such as DockerHub.
- Ensure that every container is built from the penultimate stable version
of Alpine Linux or from Debian Buster. If a Dockerfile does not start
with 'FROM alpine' or 'FROM debian:buster', or any other local image,
the evaluation process ends now.
- The Docker images must have the same name as their corresponding
service. Otherwise, the evaluation process ends now.
- Ensure that the Makefile has set up all the services via docker-compose.
This means that the containers must have been built using docker-compose
and that no crash happened. Otherwise, the evaluation process ends.


Docker Network

- Ensure that docker-network is used by checking the docker-compose.yaml
file. Then run the 'docker network ls' command to verify that a
network is visible.
- The evaluated student has to give you a simple explanation of
docker-network.
If any of the above points is not correct, the evaluation process ends
now.


NGINX with SSL/TLS

- Ensure that there is a Dockerfile.
- Using the 'docker-compose ps' command, ensure that the container was
created (using the flag '-p' is authorized if necessary).
- Try to access the service via http (port 80) and verify that you
cannot connect.
- Open https://login.42.fr/ in your browser, where login is the login
of the evaluated student. The displayed page must be the configured
WordPress website (you shouldn't see the WordPress Installation page).
- The use of a TLS v1.2/v1.3 certificate is mandatory and must be
demonstrated. The SSL/TLS certificate doesn't have to be recognized.
A self-signed certificate warning may appear.
If any of the above points is not clearly explained and correct, the
evaluation process ends now.


WordPress with php-fpm and its volume

- Ensure that there is a Dockerfile.
- Ensure that there is no NGINX in the Dockerfile.
- Using the 'docker-compose ps' command, ensure that the container was
created (using the flag '-p' is authorized if necessary).
- Ensure that there is a Volume. To do so:
Run the command 'docker volume ls' then 'docker volume inspect
'. Verify that the result in the standard output contains
the path '/home/login/data/', where login is the login of the evaluated
student.
- Ensure that you can add a comment using the available WordPress user.
- Sign in with the administrator account to access the Administration
dashboard. The Admin username must not include 'admin' or 'Admin'
(e.g., admin, administrator, Admin-login, admin-123, and so forth).
- From the Administration dashboard, edit a page. Verify on the website
that the page has been updated.
If any of the above points is not correct, the evaluation process ends
now.

MariaDB and its volume

- Ensure that there is a Dockerfile.
- Ensure that there is no NGINX in the Dockerfile.
- Using the 'docker-compose ps' command, ensure that the container was
created (using the flag '-p' is authorized if necessary).
- Ensure that there is a Volume. To do so:
Run the command 'docker volume ls' then 'docker volume inspect
'. Verify that the result in the standard output contains
the path '/home/login/data/', where login is the login of the evaluated
student.
- The evaluated student must be able to explain you how to login into
the database. Try to login into the SQL database as root but with no
password. If the login is successful, the evaluation process ends now.


- Try to login into the SQL database with the user account and its
password. Verify that the database is not empty.
If any of the above points is not correct, the evaluation process ends
now.

Persistence!

- This part is pretty straightforward. You have to reboot the virtual
machine. Once it has restarted, launch docker-compose again. Then,
verify that everything is functional, and that both WordPress and
MariaDB are configured. The changes you made previously to the
WordPress website should still be here.
If any of the above points is not correct, the evaluation process ends
now.



