# Minecraft ... failover (yeah we'll call it that) setup
Services: 
* Minecraft.service is used to start the minecraft server. The service is created, but not enabled so that it doesn't start automatically. There's also a startlimitinterval specified so that if for some reason the server isn't able to start it doesn't just keep trying indefinitely. 
* Checkminecraft.service is used to start minecraft.service based on which conditions pass/fail in checkmc.sh This server is created and enabled so that from the time the machine boots it's checking the status of the remote minecraft server then the local server

Script:
* checkmc.sh does the following:
  - checks if the remote server is online, running, stopping, or stopped. If the remote server is stopped or offline it will start the local server's instance of minecraft after verifying that it is not already running or stopping
